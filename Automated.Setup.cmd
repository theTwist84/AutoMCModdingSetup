@Echo Off
SET forgeVer=10.13.2.1235
:DLForge
IF NOT EXIST "%CD%\forge-1.7.10-%forgeVer%-src.zip" (
	wget -c --no-check-certificate --no-cookies "http://files.minecraftforge.net/maven/net/minecraftforge/forge/1.7.10-%forgeVer%/forge-1.7.10-%forgeVer%-src.zip" -O forge-1.7.10-%forgeVer%-src.zip
) ELSE (
	GOTO DLJDK
)
:DLJDK
IF NOT EXIST "%CD%\jdk-.zip" (
	wget -c --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/7u65-b19/jdk-7u65-windows-i586.exe" -O jdk-.zip
) ELSE (
	GOTO DLEclipse
)
:DLEclipse
IF NOT EXIST "%CD%\eclipse.zip" (wget -c --no-check-certificate --no-cookies "http://download.eclipse.org/technology/epp/downloads/release/luna/R/eclipse-jee-luna-R-win32-x86_64.zip" -O eclipse.zip
) ELSE (
	GOTO XForge
)
:XForge
IF NOT EXIST "%CD%\forge-1.7.10-src" (
	7z x forge-1.7.10-%forgeVer%-src.zip -oforge-1.7.10-src
) ELSE (
	GOTO XEclipse
)
:XEclipse
IF NOT EXIST "%CD%\eclipse" (
	7z x eclipse.zip
) ELSE (
	GOTO XJDK
)
:XJDK
IF NOT EXIST "%CD%\jdk" (
	7z x jdk-*.zip & MOVE /Y %CD%\tools.zip jdk.zip & 7z x jdk.zip -ojdk & DEL /Q %CD%\jdk.zip & GOTO UnpackJDK
) ELSE (
	GOTO ForgeSetup
)
:UnpackJDK
for /r %%x in (*.pack) do %CD%\jdk\bin\unpack200 -r "%%x" "%%~dx%%~px%%~nx.jar"
SET JAVA_HOME=.\jdk

:ForgeSetup
IF EXIST "%CD%\forge-1.7.10-src" (
	PUSHD %CD%\forge-1.7.10-src & GOTO setupWorkspace
)
:setupWorkspace
SET JAVA_HOME=..\jdk
IF NOT EXIST "%CD%\build" (
	%CD%\gradlew setupDecompWorkspace & %CD%\gradlew setupDevWorkspace & %CD%\gradlew eclipse & POPD & %COMSPEC% /c %CD%\..\StartEclipse.vbs
) ELSE (
	POPD & %COMSPEC% /c %CD%\..\StartEclipse.vbs
)
