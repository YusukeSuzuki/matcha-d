module matcha.math.types.rectangle;

struct Rectangle
{
	long x;
	long y;
	long w;
	long h;

	invariant()
	{
		assert(w >= 0 && h >= 0);
	}

	this(long x, long y, long w, long h)
	{
		this.x = x;
		this.y = y;
		this.w = w;
		this.h = h;
	}
}

