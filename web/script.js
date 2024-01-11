function copyBase64ImageToClipboard(base64Image) {
  // 檢查並去除 Base64 字符串中的前綴
  const base64Data = base64Image.split(',')[1] || base64Image;

  // 將 Base64 字符串轉換為 Blob
  const blob = new Blob([Uint8Array.from(atob(base64Data), c => c.charCodeAt(0))], { type: 'image/png' });

  // 使用 Clipboard API 複製圖片
  navigator.clipboard.write([
    new ClipboardItem({ 'image/png': blob })
  ]).then(function() {
    console.log('Image copied to clipboard!');
  })
  .catch(function(error) {
    console.error('Copy to clipboard failed: ', error);
  });
}