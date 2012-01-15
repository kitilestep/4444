(
~a4444[\define].value(\whine, {
		(octavemod: wchoose((1..22), ([8,16,12,8] ++ {1}.dup(18)).normalizeSum),
		 instrument: wchoose([\docp44441, \chippychord44441, \whineflect44441, \booble44441], [0.4, 0.2, 0.2, 0.2]).postln.postln,
		 amp: rrand(0.04, 0.07),
		 moddepth: exprand(50, 400),
		 durscale: wchoose([0.25, 0.333333333, 0.5, 1], [0.2, 0.1, 0.6, 0.1])
		)
	}, { |curebbs, vars|
	PmonoArtic(
		vars[\instrument].postln,
		\dur, Pconst(4, Pwrand([1,2,3] * vars[\durscale], [0.1, 0.4, 0.5], inf)),
		// TODO: use curebbs[\density] to determine number of on-notes?
		\midinote, Pseq({rrand(70, 100)}.dup(20), inf),
		\slur, exprand(0.01, 0.1),
		\amp, vars[\amp],
		\octavemod, vars[\octavemod],
		\panwidth, 1.0.rand,
		\modrate, [0.0005, 0.0001, 0.005].choose,
		\moddepth, vars[\moddepth],
		\legato, Pseq({[1, 0.98].choose}.dup(12), inf)
	)
}, makebuild: nil);
~a4444[\d][\whine][\onprob] = { |curebbs| curebbs[\arousal] * 0.7 * curebbs[\density].linlin(0,0.9, 0.5, 1) };
//~a4444[\d][\whine][\onprob] = 1;
);

