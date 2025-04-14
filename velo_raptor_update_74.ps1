[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$url = 'https://github.com/varijot/raptor74/raw/main/MyDFIR-Velociraptor741.exe'
$fileName = [System.IO.Path]::GetFileName($url)
$output = "C:\Temp\$fileName"

# Patikriname, ar C:\Temp direktorija egzistuoja, jei ne – sukuriame ją
if (-not (Test-Path 'C:\Temp')) {
    New-Item -ItemType Directory -Path 'C:\Temp'
}

# Atsisiunčiame naują Velociraptor diegimo failą
Invoke-WebRequest -Uri $url -OutFile $output

# Stabdykite esamą Velociraptor paslaugą, jei ji veikia
Stop-Service -Name 'Velociraptor' -ErrorAction SilentlyContinue

# Pašalinkite esamą Velociraptor paslaugą
sc.exe delete Velociraptor

# Įdiekite naują Velociraptor klientą
Start-Process -FilePath $output -ArgumentList 'service', 'install' -Wait

# Paleiskite Velociraptor paslaugą
Start-Service -Name 'Velociraptor'