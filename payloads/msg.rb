require 'Win32API'

mb = Win32API.new("user32", "MessageBox", ['i','p','p','i'], 'i')
mb.call(0, 'A message from your friendly Citation Client.', "A Message", 0)
