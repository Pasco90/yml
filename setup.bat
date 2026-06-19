@echo off
REM ============================================================
REM  setup.bat - A LANCER AVANT npkm-coni
REM  Monte le partage SMTB (chemin japonais) sur le lecteur S:
REM  IMPORTANT : sauvegarder ce fichier en encodage ANSI / Shift-JIS
REM  (sinon cmd ne lit pas correctement les caracteres japonais)
REM ============================================================

REM Supprime un eventuel S: deja monte (ignore l'erreur s'il n'existe pas)
subst S: /d >nul 2>&1

REM Monte le partage sur S:
subst S: "\\Sv01tpfile01\allow_remoteaccess\01_システムコード別\517-CALYPSO\01.案件\01.2.案件_開発\01.2.1.開発案件ドキュメント\25\A28204-01.CalypsoV19バージョンアップ対応\99_WORK\共有\Tool"

if errorlevel 1 (
    echo [ERREUR] Echec du montage de S:. Verifier l'acces au partage.
    exit /b 1
)

echo [OK] Lecteur S: monte. Lancer maintenant : npkm-coni .\main.yml
dir S:
