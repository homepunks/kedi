ODINFLAGS := -vet -strict-style

.PHONY: clean

kedi: src
	odin build src -out:kedi $(ODINFLAGS)

clean:
	rm -f kedi
