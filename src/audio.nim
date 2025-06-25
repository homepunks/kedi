import raylib

var bgMusic*: Music

proc initAudio*() =
  initAudioDevice()
  bgMusic = loadMusicStream("./assets/jordie.mp3")
  playMusicStream(bgMusic)

proc updateAudio*() =
  updateMusicStream(bgMusic)

proc closeAudio*() =
  stopMusicStream(bgMusic)
  closeAudioDevice()
