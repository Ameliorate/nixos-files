function mdl1
	youtube-dl -i --extract-audio --audio-format mp3 -o "/mnt/hdd/music/1/%(title)s.%(ext)s" $argv
	youtube-dl -o "/mnt/hdd/musicvideo/1/%(title)s.%(ext)s" $argv
end
