module matcha.math.saturate_cast;

import std.algorithm;
import std.traits;

unittest { import std.stdio; writeln(__MODULE__, " : test start"); }

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
			(isIntegral!(To) && isSigned!(To) && To.sizeof <= From.sizeof)
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
			(isIntegral!(To) && isSigned!(To) && To.sizeof > From.sizeof)
		)
	)
{
	return u;
}

To saturate_cast(To,From)(From u)
	if
	(
		isSigned!(From) && isIntegral!(From) &&
		__traits(isIntegral, To) && To.sizeof < From.sizeof
	)
{
	return ciel_floor_cast!(To)(u);
}

To saturate_cast(To,From)(From u)
	if
	(
		isSigned!(From) && isIntegral!(From) &&
		__traits(isUnsigned, To) && To.sizeof >= From.sizeof
	)
{
	return floor_cast!(To)(u);
}

To saturate_cast(To,From)(From u)
	if
	(
		isSigned!(From) && isIntegral!(From) &&
		isSigned!(To) && To.sizeof >= From.sizeof
	)
{
	return u;
}

To saturate_cast(To, From)(From u)
	if( __traits(isFloating, To, From) && __traits(isSame, To, From) )
{
	return u;
}

To saturate_cast(To, From)(From u)
	if( __traits(isFloating, To, From) && !__traits(isSame, To, From) &&
		To.max < From.max)
{
	return cast(To)(
		max( cast(From)(-To.max), min( cast(From)(To.max), u) )
		);
}

To saturate_cast(To, From)(From u)
	if( __traits(isFloating, To, From) && !__traits(isSame, To, From) &&
		To.max >= From.max)
{
	return cast(To)(u);
}

To saturate_cast(To, From)(From u)
	if( __traits(isFloating, From) && __traits(isIntegral, To) )
{
	return u > long.max ?
		saturate_cast!(To)( cast(ulong)(min(ulong.max, u)) ) :
		saturate_cast!(To)( max(long.min, cast(long)(min(long.max, u))) );
}

To saturate_cast(To, From)(From u)
	if( __traits(isIntegral, From) && __traits(isFloating, To) )
{
	return cast(To)(u);
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

	{
		writeln( saturate_cast!(float)( cast(ulong)(ulong.max) ) );
		writeln( float.max_exp );
		assert( saturate_cast!(ubyte)( cast(float)(1000000) ) == ubyte.max);
		assert( saturate_cast!(float)( cast(double)(double.max) ) == float.max );
	}
}

unittest { import std.stdio; writeln(__MODULE__, " : test clear"); }

