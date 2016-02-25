echo ((Get-WmiObject SoftwareLicensingProduct | where Name -match 'windows' | where LicenseStatus -ne 0) | select -First 1)
echo Get-WmiObject SoftwareLicensingService

get-ciminstance -class SoftwareLicensingProduct |
  where {$_.name -match ‘windows’ -AND $_.licensefamily} |
    format-list -property Name, Description, `
             @{Label=”Grace period (days)”; Expression={ $_.graceperiodremaining / 1440}}, `
             @{Label= “License Status”; Expression={switch (foreach {$_.LicenseStatus}) `
              { 0 {“Unlicensed”} `
                1 {“Licensed”} `
                2 {“Out-Of-Box Grace Period”} `
                3 {“Out-Of-Tolerance Grace Period”} `
                4 {“Non-Genuine Grace Period”} `
                5 {“Notification Period”} `
                6 {“Extended Grace Period”} `
              } } }