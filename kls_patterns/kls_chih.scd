(
~a4444[\define].value(\chih, {
		(
			pos: 4.rand + ((3.rand + 1) / 4),
			topfreq: exprand(10000, 20000),
			mix: rrand(0.7, 1.0), 
			room: 1.0.rand, 
			damp: 1.0.rand
		)
	}, { |curebbs, vars|
		//~a4444[\d][\chih][\everynbars] = [2,4].choose;
		Pbind(
			\instrument, \chih4444ds1,
			\dur, Pseq([vars[\pos], 4-vars[\pos]]),
			\amp, rrand(0.03, 0.08),
			\pan, 1.0.bilinrand,
			\topfreq, vars[\topfreq],
			\mix,  vars[\mix],
			\room, vars[\room],
			\damp, vars[\damp],
			\midinote, Pseq([\, Pwrand([60, \ ], [1.0.rand, 4].normalizeSum)])
		)
	});
~a4444[\d][\chih][\onprob] = { |curebbs| curebbs[\density].linlin(0, 1, 1, 0) * curebbs[\arousal].linlin(0.275, 1, 1, 0) };
//~a4444[\d][\chih][\onprob] = 1;
~a4444[\d][\chih][\maypull] = false;
);

