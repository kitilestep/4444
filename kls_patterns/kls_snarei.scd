(
~a4444[\define].value(\snarei, {
		(
			panwidth: [0, 0.05, 0.5].choose,
			panhop: 1.0.rand
		)
	}, { |curebbs, vars|
	Pbind(
		\instrument, \snarei44441,
		\dur, Pconst([1.5, 4].wchoose([0.3, curebbs[\density]].normalizeSum), Pwrand([1,2,3] * 0.125, [0.1, 0.4, 0.5], inf)),
		\percussionon, ~a4444[\percussionon],
		\centrefreq, rrand(curebbs[\arousal].linlin(0,1, 100, 8000), 10000),
		\pan, Pbrown(0 - vars[\panwidth], vars[\panwidth], vars[\panwidth] * vars[\panhop])
	)
}, makebuild: 0.5);
~a4444[\d][\snarei][\onprob] = 0.5;
);

