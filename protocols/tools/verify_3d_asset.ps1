# verify_3d_asset.ps1 - validate a 3D file before importing into Lens Studio.
# Detects disguised files (an image saved with a .glb extension) and checks glTF structure.
# Usage:  .\verify_3d_asset.ps1 -Path "C:\...\grad_cap.glb"
# Output: PASS/FAIL + details (magic, meshes, nodes, scenes, extensionsRequired).
# Lesson: in the Graduation lens, grad_cap.glb was actually a PNG -> failed "SceneObject count: 0".
# (Messages kept in English: Windows PowerShell 5.1 reads .ps1 as ANSI; non-ASCII breaks parsing.)

param([Parameter(Mandatory=$true)][string]$Path)

$ErrorActionPreference = 'Stop'
function Fail($m){ Write-Host "FAIL: $m" -ForegroundColor Red; exit 1 }
function Ok($m){ Write-Host "OK: $m" -ForegroundColor Green }

if(-not (Test-Path $Path)){ Fail "file not found: $Path" }
$ext = [System.IO.Path]::GetExtension($Path).ToLower()
$bytes = [System.IO.File]::ReadAllBytes($Path)
if($bytes.Length -lt 20){ Fail "file too small / corrupt ($($bytes.Length) bytes)" }

$magic = [System.Text.Encoding]::ASCII.GetString($bytes[0..3])
$sizeKB = [math]::Round($bytes.Length/1KB,1)
Write-Host "File: $Path  ($sizeKB KB)  ext: $ext  magic: '$magic'"

# Detect common disguises
if($magic -match 'PNG'){ Fail "This is a disguised PNG image, not a 3D model. Download the real model (Download -> GLB), not a preview image." }
if($bytes[0] -eq 0xFF -and $bytes[1] -eq 0xD8){ Fail "This is a disguised JPEG image, not a 3D model." }

switch($ext){
  '.glb' {
    if($magic -ne 'glTF'){ Fail "Invalid GLB (magic='$magic', expected 'glTF')." }
    $ver  = [BitConverter]::ToUInt32($bytes,4)
    $clen = [BitConverter]::ToUInt32($bytes,12)
    $ctype= [System.Text.Encoding]::ASCII.GetString($bytes[16..19])
    if($ctype.Trim() -ne 'JSON'){ Fail "First chunk is not JSON (type='$ctype')." }
    $json = [System.Text.Encoding]::UTF8.GetString($bytes,20,[int]$clen)
    try { $j = $json | ConvertFrom-Json } catch { Fail "Could not parse JSON chunk inside GLB." }
    Ok "Valid GLB - glTF v$ver"
    "  meshes=$($j.meshes.Count)  nodes=$($j.nodes.Count)  scenes=$($j.scenes.Count)  materials=$($j.materials.Count)"
    if(($j.nodes.Count -eq 0) -or ($j.meshes.Count -eq 0)){ Fail "No nodes/meshes - Lens Studio will import 0 objects." }
    $req = @($j.extensionsRequired)
    if($req.Count -gt 0){
      "  extensionsRequired: $($req -join ', ')"
      if($req -contains 'KHR_draco_mesh_compression'){ Write-Host "  WARN: uses Draco compression - confirm Lens Studio supports it or decompress." -ForegroundColor Yellow }
    }
    Ok "Ready to import into Lens Studio (Ctrl+Shift+I)."
  }
  '.gltf' {
    try { $j = Get-Content $Path -Raw | ConvertFrom-Json } catch { Fail "Invalid glTF JSON." }
    if(-not $j.asset.version){ Fail "Not a glTF file (no asset.version)." }
    Ok "Valid text glTF v$($j.asset.version) - meshes=$($j.meshes.Count) nodes=$($j.nodes.Count)"
    Write-Host "  WARN: separate glTF may need companion .bin / textures." -ForegroundColor Yellow
  }
  '.fbx' {
    $hdr = [System.Text.Encoding]::ASCII.GetString($bytes[0..17])
    if($hdr -notmatch 'Kaydara'){ Write-Host "  WARN: unusual FBX header (may be old ASCII FBX)." -ForegroundColor Yellow }
    else { Ok "Valid binary FBX (Kaydara)." }
    Ok "Ready to import (check scale after import - may be large)."
  }
  '.obj' { Ok "Text OBJ - ensure .mtl and textures are present alongside." }
  default { Write-Host "  WARN: unsupported extension: $ext" -ForegroundColor Yellow }
}
exit 0
