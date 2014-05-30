import matcha.math.matrix;

import std.stdio;

int main()
{
	{
		auto m = initializedMatrix!(int)(3,3,3,1);
		writeln( m.sum );
	}

	{
		auto m1 = initializedMatrix!(int)(2,2,1,1);
		auto m2 = initializedMatrix!(int)(2,2,1,2);
		auto m3 = add(m1, m2);

		writeln(m3.sum);
	}

	return 0;
}

