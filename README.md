# Miner
Manic Miner for the Vic-20

Manic Miner is a classic game for the ZX Spectrum that has had more or less faithful ports to nearly every British home computer. VIC owners, though, had to make do with Perils of Willy, which was lacking on both the artistic and technical fronts, with uninspired level and enemy design, absurdly long jumps, and flickery sprites.

This port started out as a proof of concept on an unexpanded VIC-20, which only has about 3k of available memory.

I wanted to see if I could retain the gameplay of the first cavern with the reduced screen resolution - the VIC screen is only 22 character blocks wide by default, compared to the 32 character wide ZX Spectrum original.

I was considering several options:

I could make the platforms and jumps shorter, which would be the easiest thing to do, although it would mean I'd have to rework all of the cavern layouts.

Or, I could widen the screen to 30 character blocks (nearly all the caverns have lines of blocks on the left and right) and use the VIC's screen offsetting routines to scroll the relevant parts into view. TVs can show 26-28 characters before hitting the edges of the screen so it wouldn't have to scroll very far. The VIC can also offset the screen in half-character steps horizontally, so I thought it would look ok. Most caverns' gameplay wouldn't suffer too much, I thought.

Lastly, I could lay out the screen in 6x8 pixel blocks, so that I could fit 32 blocks on each line into 24 characters. Since the VIC, like the Spectrum, only allows colors per character, I would probably end up with pretty severe colour clash, plus the screen would almost have to be bitmapped, which would consume more memory. Plus, I'd have to redraw all the sprites and tiles so they were 3/4 the width. Not at all ideal.

On the Spectrum, the caverns are stored uncompressed, one byte per tile, so the screen layout is 512 bytes. There's also another 500-odd bytes of data for enemy positions and graphics, tile definitions, and so on.  For 20 caverns that's 20k, which is way too much. It's much more efficient to store the screen as strips of tiles, and nearly as easy to draw the screen from that data.

I was able to make the first cavern look almost the same at 22 characters wide, and I was pretty confident that would work for the rest of the caverns.
