ODINFLAGS := -vet -strict-style

kedi:
	odin build src -out:kedi $(ODINFLAGS)
