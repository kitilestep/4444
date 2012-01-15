(
~a4444[\define].value(\kick, {
		()
	}, { |curebbs|
	var tmp;
	Pbind(
		\instrument, \kick4444dsjl,
		\freqa, exprand(20, 120),
		// trebley onset of kick controlled by arousal ebb
		\freqb, exprand(50, curebbs[\arousal].linexp(0, 1, 50, 1000)),
		\len, exprand(0.005, 0.04),
		\percussionon, ~a4444[\percussionon],
		\dur, if(curebbs[\density] < 0.3){
			tmp = 26.rand;
			Pseq([0.75] ++ ([tmp, 26-tmp]/8)) // bit like a beatdown kick pattern
		}{
			Pshuf([0.25, 0.25, 0.5, 1, 1, 0.5, 0.5])
		}
	)
}, makebuild: { |item, numbars, gapbeats, curebbs|
	var list;
	[{
	Pbind(
		\instrument, \kick4444dsjl,
		\freqa, rrand(20, 40),
		\freqb, Pseries(0, 1/(numbars*4)).min(1).linexp(0, 1, 50, 300),
		\len, exprand(0.005, 0.02),
		\percussionon, ~a4444[\percussionon],
		\dur, Pseq([
			Pseq([1], (numbars-1) * 4 - gapbeats),
			Pseq([8, 8, 4, 2, 2, 1,1,1,1, 1,1,1,1]/8)
			])
	)},
	{
	Pbind(
		\instrument, \kick4444dsjl,
		\freqa, rrand(20, 40),
		\freqb, Pseries(0, 1/(numbars*4)).min(1).linexp(0, 1, 50, 300),
		\len, exprand(0.005, 0.02),
		\percussionon, ~a4444[\percussionon],
		\dur, Pseq([4], ceil(numbars - (gapbeats * 0.25)))
	)},
	{
		list = [true] ++ {wchoose([true, false], [0.3, 0.7])}.dup(15);
		Pfindur(numbars * 4 - gapbeats, 
		Pbind(
			\instrument, \kick4444dsjl,
			\freqa, rrand(20, 40),
			\len, exprand(0.005, 0.02),
			// 'freq' arg used since it lets us insert rests
			[\freq, \amp], Pif(Pseq(list, inf), [60, 0.1], Pif(Pwhite()<Pseries(-0.08, [0.005, 0.01, 0.02].choose), [60, 0.075], [\, 0.1]) ),
			\percussionon, ~a4444[\percussionon],
			\dur, 1/8
	))}].choose.value
});
);

