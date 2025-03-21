try
{
    # Boxstarter options
    $Boxstarter.RebootOk = $true # Allow reboots?
    $Boxstarter.NoPassword = $false # Is this a machine with no login password?
    $Boxstarter.AutoLogin = $true # Save my password securely and auto-login after a reboot

    choco feature enable -n allowGlobalConfirmation

    # Basic setup
    Update-ExecutionPolicy Unrestricted
    Set-WindowsExplorerOptions -EnableShowHiddenFilesFoldersDrives -EnableShowProtectedOSFiles -EnableShowFileExtensions -EnableShowFullPathInTitleBar -EnableOpenFileExplorerToQuickAccess -EnableShowRecentFilesInQuickAccess -EnableShowFrequentFoldersInQuickAccess -EnableExpandToOpenFolder -EnableShowRibbon
    Set-BoxstarterTaskbarOptions -Size Large -Dock Bottom -AlwaysShowIconsOn
    Disable-InternetExplorerESC
    Disable-GameBarTips
    Enable-RemoteDesktop

    # Virtualisation
    Enable-WindowsOptionalFeature -Online -NoRestart -FeatureName Containers
    Enable-WindowsOptionalFeature -Online -NoRestart -FeatureName Microsoft-Hyper-V-All
    Enable-WindowsOptionalFeature -Online -NoRestart -FeatureName VirtualMachinePlatform
    Enable-WindowsOptionalFeature -Online -NoRestart -FeatureName Microsoft-Windows-Subsystem-Linux
    if (Test-PendingReboot) { Invoke-Reboot }
    wsl --set-default-version 2
    choco install wsl-ubuntu-2204
    choco install vagrant

    # IIS
    Enable-WindowsOptionalFeature -Online -All -NoRestart -FeatureName IIS-ASPNET45

    choco install urlrewrite

    if (Test-PendingReboot) { Invoke-Reboot }

    # Essential Tools
    choco install 7zip
        choco install greenshot
    choco install hostsman
    choco install grepwin
    choco install microsoft-windows-terminal
    choco install terminal-icons.powershell --package-parameters="/core /desktop"
    choco install terminals
 

    # Setup Scoop
    if (!(Test-Path -Path '~/scoop')) {
        Invoke-Expression "& {$(Invoke-RestMethod get.scoop.sh)} -RunAsAdmin"
    }

    # Install nodejs
    choco install nvm
    nvm install latest
    nvm use latest

    # CLI Setup
    choco install oh-my-posh
    choco install sudo
    choco install font-nerd-dejavusansmono
    [environment]::setEnvironmentVariable('PSModulePath',"$env:OneDrive\Documents\WindowsPowerShell\Modules",'User')
    refreshenv
    choco install powershell-core
    Install-Module z -Scope CurrentUser -Force
    Install-Module -Name PSReadLine -Scope CurrentUser -Force -SkipPublisherCheck

    # Text Editors
    choco install vscode
    choco install notepadplusplus
    choco install vim

    # Browsers
    choco install firefox
    choco install google-chrome-x64
    choco install opera

    # DevTools - Frameworks
    choco install dotnet # 6.0
    choco install dotnet-sdk # 6.0-sdk
    choco install dotnet4.6
    choco install dotnet4.6.1
    choco install windows-sdk-10
    choco install netfx-4.6-devpack
    choco install netfx-4.6.1-devpack

    if (Test-PendingReboot) { Invoke-Reboot }

    #DevTools - Source Control
    choco install git
    choco install git-credential-manager-for-windows
    choco install sourcetree
    choco install poshgit
    choco install p4merge

    # DevTools - IDE's
    choco install jetbrainstoolbox
    choco install linqpad6

    if (Test-PendingReboot) { Invoke-Reboot }

    # DevTools - Misc
    choco install nugetpackageexplorer
    choco install devtoys
    choco install fiddler
    choco install awscli
    iex "& { $(irm https://aka.ms/install-artifacts-credprovider.ps1) } -AddNetfx"

    if (!(Test-Path -Path 'C:\source')) {
        mkdir C:\source
    }

    Write-ChocolateySuccess 'Dev-Machine-Setup'
}
catch
{
    throw $_.Exception
}