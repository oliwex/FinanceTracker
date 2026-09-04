function New-AudioNotification
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory,HelpMessage = "Text to Speak")]
        [Alias("Text")]
        $textToSpeak
    )

    begin
    {
        if ((Get-Service AudioSrv).Status -notlike "*Running*")
        {
            Get-Service AudioSrv | Start-Service
        }
        Add-Type -AssemblyName System.speech
        $speak = New-Object System.Speech.Synthesis.SpeechSynthesizer
    }
    process 
    {
        $speak.Speak($textToSpeak)
    }
    end
    {}
}