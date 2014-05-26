import matcha.math.matrix;

import std.stdio;

int main()
{
	auto m = initializedMatrix!(int)(3,3,3,1);
	writeln( m.sum );

	return 0;
}


