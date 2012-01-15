(
~a4444[\define].value(\eerie, {
		// rarefunc chooses note
		(midinote:  rrand(55, 105))
	}, { |curebbs, vars|
	Pbind(
		\instrument, \eerie44441,
		\dur, Pseq([16], 1),
		// play louder (eerier) when low valence
		\amp, curebbs[\valence].linexp(0, 1, 0.1, 0.0001),
		\midinote, vars[\midinote],
		\legato, 1
	)
}, 4, makebuild: nil, duckunder: \snareo);
~a4444[\d][\eerie][\onprob] = { |curebbs| (1 - curebbs[\density]) * 0.5 };
~a4444[\d][\eerie][\maypull] = false;
);

