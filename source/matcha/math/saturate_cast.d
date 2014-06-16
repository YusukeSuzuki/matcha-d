module matcha.math.saturate_cast;

import std.algorithm;
import std.traits;

private To ciel_cast(To,From)(From u)
{
	return cast(To)( min(To.max, u) );
}

private To floor_cast(To,From)(From u)
{
	return cast(To)( max(To.min, u) );
}

private To ciel_floor_cast(To,From)(From u)
{
	return cast(To)( min(To.max, max(To.min, u)) );
}

To saturate_cast(To,From)(From u)
	if
	(
		__traits(isUnsigned, From) &&
		(
			(__traits(isUnsigned, To) && To.sizeof < From.sizeof) ||
			(isSigned!(To) && To.sizeof <= From.sizeof)
		)
	)
{
	return ciel_cast!(To)(u);
}

To saturate_cast(To,From)(From u)
	if
	(
		__traits(isUnsigned, From) &&
		(
			(__traits(isUnsigned, To) && To.sizeof >= From.sizeof) ||
			(isSigned!(To) && To.sizeof > From.sizeof)
		)
	)
{
	return u;
}

To saturate_cast(To,From)(From u)
	if
	(
		isSigned!(From) &&
		__traits(isIntegral, To) && To.sizeof < From.sizeof
	)
{
	return ciel_floor_cast!(To)(u);
}

To saturate_cast(To,From)(From u)
	if
	(
		isSigned!(From) &&
		__traits(isUnsigned, To) && To.sizeof >= From.sizeof
	)
{
	return floor_cast!(To)(u);
}

To saturate_cast(To,From)(From u)
	if
	(
		isSigned!(From) &&
		isSigned!(To) && To.sizeof >= From.sizeof
	)
{
	return u;
}

unittest
{
	import std.stdio;

	{
		// from positive big int
		immutable long from = long.max;

		assert(saturate_cast!(ubyte)(from) == ubyte.max);
		assert(saturate_cast!(ushort)(from) == ushort.max);
		assert(saturate_cast!(uint)(from) == uint.max);
		assert(saturate_cast!(ulong)(from) == long.max);

		assert(saturate_cast!(byte)(from) == byte.max);
		assert(saturate_cast!(short)(from) == short.max);
		assert(saturate_cast!(int)(from) == int.max);
		assert(saturate_cast!(long)(from) == long.max);
	}

	{
		// from negative big int
		immutable long from = long.min;

		assert(saturate_cast!(ubyte)(from) == 0);
		assert(saturate_cast!(ushort)(from) == 0);
		assert(saturate_cast!(uint)(from) == 0);
		assert(saturate_cast!(ulong)(from) == 0);

		assert(saturate_cast!(byte)(from) == byte.min);
		assert(saturate_cast!(short)(from) == short.min);
		assert(saturate_cast!(int)(from) == int.min);
		assert(saturate_cast!(long)(from) == long.min);
	}

	writeln(__MODULE__, " : test clear");
}

