function mdl
	youtube-dl -i --extract-audio --audio-format mp3 -o "/mnt/hdd/music/weeb/%(title)s.%(ext)s" $argv
	youtube-dl -o "/mnt/hdd/musicvideo/weeb/%(title)s.%(ext)s" $argv
end
