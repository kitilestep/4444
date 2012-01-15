(
~num_wob_mansters = 5; // 1 is removed by .scramble[1..]
~a4444[\define].value(\wob, {
		// redefine the wob synths, rarely
		(Document.dir +/+ "kls_synthdefs/bass_dynamic.scd").load;
		(
			// rarely change the manster raw stickbreak (will be combined with dynamic ebb value)
			manster_rawsb: ~a4444[\stickbreakraw].value(~num_wob_mansters).scramble,
			overtonestrength: 1.0.rand,
			nonwobmod: 1.0.rand,
			wobfastness: wchoose([0.5, 1, 2], [0.2, 0.6, 0.2]),
			// Two wobbers, but they might actually (quie often) be the same
			wobber: { wchoose([\wobtest2_4444, \muzh_4444, \werwub44441], [0.6, 0.35, 0.05]) }.dup(2)
		)
	}, { |curebbs, vars|
	var tmp, longs, holdnote, midinotes;
	holdnote = curebbs[\density].linlin(0.1, 0.7, 0.3, 0.01).coin;
	midinotes = if(holdnote){(
				(0..23).wchoose(~a4444[\key] ++ ~a4444[\key])
					+ 30
			).dup(20)}{{
				(0..23).wchoose(~a4444[\key] ++ ~a4444[\key])
					+ 30
			}.dup(20)
			};
	midinotes = midinotes.collect{|n| n + if(curebbs[\arousal].linlin(0.7, 1.0, 0, 0.2).coin){36}{0} };
	vars[\midinotes] = midinotes; // store em
	vars[\whichwobber] = 2.rand;
	longs = midinotes.collect{if(curebbs[\density].coin){1}{0}};
	vars[\longs] = longs; // store em
	PmonoArtic(
		if(curebbs[\arousal].linlin(0.3, 0.6, 0, 1).coin){vars[\wobber][vars[\whichwobber]]}{\bassnonwob44441}.postln,
		//\muzh_4444, // TEMP
		\dur, Pseq({[1,2,4,8].choose}.dup(10).normalizeSum * 4),
		\midinote, Pseq(midinotes),
		\amp, 0.06,
		// a possible tweak: use .scramble rather than Prand to fix some patterns
		//  (but allow to Prand them if v excited?)

		\wobrate, Pkey(\dur).reciprocal * Prand([1,2,3,4,6,8,12], inf) * Pwrand([0, 1], [0.125, 0.875] * vars.wobfastness, inf),
		\whichphase, Prand([0,1,2,3], inf),
		\wobmin, Pwhite(20, 200, inf),
		\wobmax, Pwhite(curebbs[\arousal].linlin(0.7,0.99, 200, 10000), 
		                curebbs[\arousal].linlin(0.4,0.9, 1000, 10000), inf),
	//	\wobbuild,  Pkey(\dur) * Pwhite(0.125 * 0.125, 1, inf).squared * Pwrand([0, 1], [0.125, 0.875], inf),
		\wobbuild,  Pkey(\dur) * rrand(0.125, 1), //Pwhite(0.125 * 0.125, 1, inf).squared * Pwrand([0, 1], [0.125, 0.875], inf),
		\wobstart, exprand(20, 10000), // Pwhite(20, 10000, inf),
		// manster probys are sampled by a modified-dirichlet-like approach
		\manster, Pwrand((0..~num_wob_mansters), 
			~a4444[\stickbreak1plus].value(~num_wob_mansters+1, curebbs[\arousal].linlin(0,1,1,0.5), rawsb: vars[\manster_rawsb]), inf),
		\legato, Pseq({[1, 0.98].choose}.dup(12), inf),
		\overtonestrength, vars[\overtonestrength],
		\nonwobmod       , vars[\nonwobmod],
		\long,       Pseq(longs),
		\trig, 1
	)
}, duckunder: \kick);

~a4444[\d][\wob][\makebuild] = { |item, numbars, gapbeats, curebbs|
	// NB wob amplitude always slightly less than for the drop.
	
	// single spinup note, which we do by dividing into v short
	var numbeats = numbars * 4 - gapbeats;
	var numticks = numbeats * 8;
	var startnote = (item[\vars][\midinotes] ?? {[24]}) [0];
	var riseamount = [0, 12, 24, 36, 48].at(curebbs[\arousal].linlin(0.5, 1, 0, 4).round.asInt) ? 24;
	[
	Pfx(
		Pmono(
			if(curebbs[\arousal].linlin(0.3, 0.6, 0, 1).coin){item.vars[\wobber][item.vars[\whichwobber]]}{\bassnonwob44441},
			\dur, 0.125,
			\amp, 0.04, // bit quieter than main
			\midinote, Pseries(startnote, riseamount / numticks, numticks),
			\fractionthrough, Pseries(0, 1 / numticks, numticks),
			\wobmax, Pseries(200, curebbs[\arousal].linlin(0.4, 0.9, 1000, 10000) / numticks, numticks),
			\wobrate, TempoClock.default.tempo * [
						{Pgeom(1, 2.pow( 8/numticks), inf)},
						{Pgeom(1, 2.pow(-8/numticks), inf)},
						{[0.125, 0.25, 0.5, 1, 2, 4].choose},
					].choose.value,
			\whichphase, Prand([0,1,2,3], inf)
			)
			, \hpf44441, \cutoff, exprand(100, 1000), \dur, (numbeats / TempoClock.default.tempo)
		),
	Pfindur(numbars * 4 - gapbeats, Pseq([Pcollect({|ev| ev.wobmax = ev.wobmax.min(500); ev.manster = 0;}, item[\patt])], numbars))
	].choose;
};
~a4444[\d][\wob][\maypull] = false;
);

