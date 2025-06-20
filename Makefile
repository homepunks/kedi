# yes i dont wanna use nimble
#   for building, so what?

default:
	nim c -o:./build/oyun src/main.nim
run:
	nim c -o:./build/oyun src/main.nim
	./build/oyun
