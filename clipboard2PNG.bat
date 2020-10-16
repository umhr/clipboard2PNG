@powershell -windowstyle hidden -NoProfile -ExecutionPolicy Unrestricted "&([ScriptBlock]::Create((cat -encoding utf8 \"%~f0\" | ? {$_.ReadCount -gt 2}) -join \"`n\"))" %*
@exit /b

Add-Type -AssemblyName System.Windows.Forms;
[System.Drawing.Image]$clipboardImage = [Windows.Forms.Clipboard]::GetImage();

if ($clipboardImage -eq $null)
{
  # クリップボード上に画像が無い場合は SnippingTool を起動
  # Start-Process -FilePath "C:\WINDOWS\system32\SnippingTool.exe";

  # クリップボード上に画像が無い場合はフルスクリーンをキャプチャ
  [Windows.Forms.Sendkeys]::SendWait("{PrtSc}");
  Start-Sleep -Milliseconds 250
  $clipboardImage = [Windows.Forms.Clipboard]::GetImage();
}

if ($clipboardImage -ne $null)
{
  # 名前をつけて、batと同じ階層に保存
  [String]$fileName = (Get-Date).ToString("yyyyMMdd_HHmmss") + ".png";
  $clipboardImage.Save($fileName);
}
