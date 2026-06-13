import raylib

var bgMusic*: Music
var eatSound*: Sound
var meowSound*: Sound

proc initAudio*() =
  initAudioDevice()
  bgMusic = loadMusicStream("./assets/jordie.mp3")
  playMusicStream(bgMusic)

  eatSound = loadSound("./assets/eat.mp3")
  meowSound = loadSound("./assets/meow.mp3")

proc updateAudio*() =
  updateMusicStream(bgMusic)

proc closeAudio*() =
  stopMusicStream(bgMusic)
  closeAudioDevice()

