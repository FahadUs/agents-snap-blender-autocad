// GameManager.js — reusable AR Lens Game template (Lens Studio 5.x / JS)
// snap_015 — Snap Lens Delivery Pipeline (game path)
// Pattern: a "catch" game — spawn falling targets; player scores by triggering an input
// (open mouth / tap / smile) when a target is in the catch zone. Lives + difficulty ramp + retry.
//
// Generic & tunable: wire the @inputs in Inspector. Swap the input trigger via a Behavior
// (Face: Mouth Opened -> Call API: onCatch) or use the built-in tap handler.
//
// States: IDLE (show start) -> PLAYING -> GAMEOVER (show retry). Tap anywhere to start/retry.
// Comments in English on purpose: Windows PowerShell-edited .js stays ASCII-safe; LS reads UTF-8 fine either way.

//@input SceneObject targetPrefabHolder   {"hint":"object that holds a target template to clone (disabled)"}
//@input SceneObject[] spawnPoints         {"hint":"optional spawn anchor objects; falls back to random screen X"}
//@input Component.Text scoreText          {"hint":"score label"}
//@input Component.Text livesText          {"hint":"lives label"}
//@input Component.Text messageText        {"hint":"start / game-over message"}
//@input Component.AudioComponent sfxScore {"hint":"score SFX"}
//@input Component.AudioComponent sfxMiss  {"hint":"miss/lose SFX"}
//@input float spawnInterval = 1.2         {"hint":"seconds between spawns (start)"}
//@input float fallSpeed = 0.8             {"hint":"target fall speed (start)"}
//@input float catchZoneY = -0.5           {"hint":"screen Y where catching is valid (-1 bottom..1 top)"}
//@input float catchTolerance = 0.25       {"hint":"how close to catch zone counts as catch"}
//@input int startLives = 3
//@input float difficultyRampSec = 8.0     {"hint":"every N sec, speed up + spawn faster"}

var STATE = { IDLE:0, PLAYING:1, GAMEOVER:2 };
var state = STATE.IDLE;
var score = 0, lives = 0;
var pool = [], active = [];
var lastSpawn = 0, lastRamp = 0, startedAt = 0;
var curInterval = 1.2, curSpeed = 0.8;

function setText(t, s){ if(t) t.text = s; }

function setMessage(s){ setText(script.messageText, s); if(script.messageText) script.messageText.getSceneObject().enabled = (s !== ""); }

function resetGame(){
    score = 0; lives = script.startLives;
    curInterval = script.spawnInterval; curSpeed = script.fallSpeed;
    for (var i=0;i<active.length;i++){ active[i].enabled = false; pool.push(active[i]); }
    active = [];
    setText(script.scoreText, "0");
    setText(script.livesText, repeat("❤", lives));   // hearts
    startedAt = getTime(); lastSpawn = getTime(); lastRamp = getTime();
}

function repeat(ch,n){ var s=""; for(var i=0;i<n;i++) s+=ch; return s; }

function startGame(){ resetGame(); state = STATE.PLAYING; setMessage(""); }

function gameOver(){
    state = STATE.GAMEOVER;
    if (script.sfxMiss) script.sfxMiss.play(1);
    setMessage("Game Over\nScore: " + score + "\nTap to retry");
}

// ----- spawning with pooling -----
function getTarget(){
    var t = pool.pop();
    if (!t && script.targetPrefabHolder){
        // clone the holder's first child as a target (author a target under the holder, disabled)
        t = script.targetPrefabHolder; // fallback: reuse holder if no pool system wired
    }
    return t;
}

function spawn(){
    var t = pool.length ? pool.pop() : null;
    if (!t) return;                 // author target instances under holder and push to pool in onAwake for real pooling
    t.enabled = true;
    var tr = t.getTransform();
    var x = (Math.sin(getTime()*7.13 + active.length) ); // pseudo-random X in [-1,1]
    var p = tr.getLocalPosition();
    tr.setLocalPosition(new vec3(x, 1.1, p.z));
    active.push(t);
}

// public input API: bind a Behavior (Mouth Opened / Tap) -> Call API -> onCatch
script.api.onCatch = function(){
    if (state === STATE.IDLE || state === STATE.GAMEOVER){ startGame(); return; }
    // catch the lowest target inside the catch zone
    for (var i=active.length-1;i>=0;i--){
        var ty = active[i].getTransform().getLocalPosition().y;
        if (Math.abs(ty - script.catchZoneY) <= script.catchTolerance){
            score += 1; setText(script.scoreText, ""+score);
            if (script.sfxScore) script.sfxScore.play(1);
            active[i].enabled = false; pool.push(active[i]); active.splice(i,1);
            return;
        }
    }
};

// tap also starts/retries and acts as catch
var tap = script.createEvent("TapEvent");
tap.bind(function(){ script.api.onCatch(); });

var upd = script.createEvent("UpdateEvent");
upd.bind(function(){
    if (state !== STATE.PLAYING) return;
    var now = getTime();

    // difficulty ramp
    if (now - lastRamp >= script.difficultyRampSec){
        curSpeed *= 1.15; curInterval = Math.max(0.4, curInterval*0.9); lastRamp = now;
    }
    // spawn
    if (now - lastSpawn >= curInterval){ spawn(); lastSpawn = now; }

    // move targets; missed if they fall below screen
    var dt = getDeltaTime ? getDeltaTime() : 0.016;
    for (var i=active.length-1;i>=0;i--){
        var tr = active[i].getTransform();
        var p = tr.getLocalPosition();
        p.y -= curSpeed * dt;
        tr.setLocalPosition(p);
        if (p.y < -1.2){
            active[i].enabled = false; pool.push(active[i]); active.splice(i,1);
            lives -= 1; setText(script.livesText, repeat("❤", Math.max(0,lives)));
            if (script.sfxMiss) script.sfxMiss.play(1);
            if (lives <= 0){ gameOver(); return; }
        }
    }
});

// init
setMessage("Tap to start");
setText(script.scoreText, "0");
