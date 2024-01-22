# makefile
#
#      ||          __  __  ___  ____   ___  ____  _____ ____
#      --         |  \/  |/ _ \|  _ \ / _ \/ ___|| ____/ ___|
# -- /    \ --    | |\/| | | | | |_) | | | \___ \|  _| \___ \
# -- \    / --    | |  | | |_| |  _ <| |_| |___) | |___ ___) |
#      --         |_|  |_|\___/|_| \_\\___/|____/|_____|____/
#      ||
#
# The main commands are:
# 
# - make all
# - make clean
# - make linux
# - make macos (not working at the moment)
# - make windows
#

# Custom parameters
APP_NAME = "godot_template"
GODOT_PROJECT = src/project.godot
GODOT_RELEASE = stable
GODOT_VERSION = 4.2


# Directories
DIR_BUILD = build
DIR_BUILD_LINUX = ${DIR_BUILD}/linux
DIR_BUILD_MACOS = ${DIR_BUILD}/macos
DIR_BUILD_WINDOWS = ${DIR_BUILD}/windows
DIR_GODOT_EXPORT_TEMPLATES = ~/.local/share/godot/export_templates/${GODOT_VERSION}.${GODOT_RELEASE}

# Application files
APP_LINUX = ${DIR_BUILD_LINUX}/${APP_NAME}.sh
APP_MACOS = ${DIR_BUILD_MACOS}/${APP_NAME}.dmg
APP_WINDOWS = ${DIR_BUILD_WINDOWS}/${APP_NAME}.exe

# Local Godot files (without path)
GODOT_ROOT = Godot_v${GODOT_VERSION}-${GODOT_RELEASE}
GODOT_EXPORT_TEMPLATES_ZIP_NOPATH = ${GODOT_ROOT}_export_templates.tpz
GODOT_NOPATH = ${GODOT_ROOT}_linux.x86_64
GODOT_ZIP_NOPATH = ${GODOT_NOPATH}.zip

# Local Godot files (with path)
GODOT = ${DIR_BUILD}/${GODOT_NOPATH}
GODOT_ZIP = ${DIR_BUILD}/${GODOT_ZIP_NOPATH}

# Local Godot export template files (with path)
GODOT_EXPORT_TEMPLATES_ZIP = ${DIR_BUILD}/${GODOT_EXPORT_TEMPLATES_ZIP_NOPATH}
GODOT_EXPORT_TEMPLATE_LINUX = ${DIR_GODOT_EXPORT_TEMPLATES}/linux_release.x86_64
GODOT_EXPORT_TEMPLATE_MACOS = ${DIR_GODOT_EXPORT_TEMPLATES}/macos.zip
GODOT_EXPORT_TEMPLATE_WINDOWS = ${DIR_GODOT_EXPORT_TEMPLATES}/windows_release_x86_64.exe

# Godot URLs
GODOT_URL_ROOT = https://downloads.tuxfamily.org/godotengine/${GODOT_VERSION}
GODOT_URL = ${GODOT_URL_ROOT}/${GODOT_ZIP_NOPATH}
GODOT_URL_EXPORT_TEMPLATES = ${GODOT_URL_ROOT}/${GODOT_EXPORT_TEMPLATES_ZIP_NOPATH}


${GODOT}:
	@tput setaf 2
	@echo
	@echo "-------------------------------------------------------"
	@echo "STARTING DOWNLOAD FOR GODOT v${GODOT_VERSION} FOR LINUX"
	@echo "-------------------------------------------------------"
	@echo
	@tput setaf 7
	@mkdir -p ${DIR_BUILD}
	curl ${GODOT_URL} --output ${GODOT_ZIP}
	7z x ${GODOT_ZIP} -o${DIR_BUILD}
	rm -f ${GODOT_ZIP}
	@tput setaf 2
	@echo
	@echo "-------------------------------------------------------"
	@echo "FINISHED DOWNLOAD FOR GODOT v${GODOT_VERSION} FOR LINUX"
	@echo "-------------------------------------------------------"
	@echo
	@tput setaf 7


${GODOT_EXPORT_TEMPLATE_LINUX}:
	make export_templates


${GODOT_EXPORT_TEMPLATE_MACOS}:
	make export_templates


${GODOT_EXPORT_TEMPLATE_WINDOWS}:
	make export_templates


all:
	make linux
	#make macos
	make windows
.PHONY: all


clean:
	@tput setaf 2
	@echo
	@echo "----------------"
	@echo "STARTING CLEANUP"
	@echo "----------------"
	@echo
	@tput setaf 7
	rm -rf ${DIR_BUILD}
	@tput setaf 2
	@echo
	@echo "----------------"
	@echo "FINISHED CLEANUP"
	@echo "----------------"
	@echo
	@tput setaf 7
.PHONY: clean


export_templates:
	@tput setaf 2
	@echo
	@echo "--------------------------------------------------------------"
	@echo "STARTING DOWNLOAD FOR GODOT v${GODOT_VERSION} EXPORT TEMPLATES"
	@echo "--------------------------------------------------------------"
	@echo
	@tput setaf 7
	@echo ${GODOT_EXPORT_TEMPLATE_LINUX}
	@mkdir -p ${DIR_BUILD}
	@mkdir -p ${DIR_GODOT_EXPORT_TEMPLATES}
	curl ${GODOT_URL_EXPORT_TEMPLATES} --output ${GODOT_EXPORT_TEMPLATES_ZIP}
	7z x ${GODOT_EXPORT_TEMPLATES_ZIP} -o${DIR_BUILD}
	cp ${DIR_BUILD}/templates/* ${DIR_GODOT_EXPORT_TEMPLATES}
	rm -f ${GODOT_EXPORT_TEMPLATES_ZIP}
	rm -rf ${DIR_BUILD}/templates
	@tput setaf 2
	@echo
	@echo "--------------------------------------------------------------"
	@echo "FINISHED DOWNLOAD FOR GODOT v${GODOT_VERSION} EXPORT TEMPLATES"
	@echo "--------------------------------------------------------------"
	@echo
	@tput setaf 7
.PHONY: export_templates


linux: ${GODOT} ${GODOT_EXPORT_TEMPLATE_LINUX}
	@tput setaf 2
	@echo
	@echo "------------------------"
	@echo "STARTING EXPORT TO LINUX"
	@echo "------------------------"
	@echo
	@tput setaf 7
	@mkdir -p ${DIR_BUILD_LINUX}
	${GODOT} -v --headless --export-release "Linux/X11" ../${APP_LINUX} ${GODOT_PROJECT}
	@tput setaf 2
	@echo
	@echo "------------------------"
	@echo "FINISHED EXPORT TO LINUX"
	@echo "------------------------"
	@echo
	@tput setaf 7
.PHONY: linux


macos: ${GODOT} ${GODOT_EXPORT_TEMPLATE_MACOS}
	@tput setaf 2
	@echo
	@echo "------------------------"
	@echo "STARTING EXPORT TO MACOS"
	@echo "------------------------"
	@echo
	@tput setaf 7
	@mkdir -p ${DIR_BUILD_MACOS}
	${GODOT} -v --headless --export-release "macOS" ../${APP_MACOS} ${GODOT_PROJECT}
	@tput setaf 2
	@echo
	@echo "------------------------"
	@echo "FINISHED EXPORT TO MACOS"
	@echo "------------------------"
	@echo
	@tput setaf 7
.PHONY: macos


windows: ${GODOT} ${GODOT_EXPORT_TEMPLATE_WINDOWS}
	@tput setaf 2
	@echo
	@echo "--------------------------"
	@echo "STARTING EXPORT TO WINDOWS"
	@echo "--------------------------"
	@echo
	@tput setaf 7
	@mkdir -p ${DIR_BUILD_WINDOWS}
	${GODOT} -v --headless --export-release "Windows Desktop" ../${APP_WINDOWS} ${GODOT_PROJECT}
	@tput setaf 2
	@echo
	@echo "--------------------------"
	@echo "FINISHED EXPORT TO WINDOWS"
	@echo "--------------------------"
	@echo
	@tput setaf 7
.PHONY: windows
