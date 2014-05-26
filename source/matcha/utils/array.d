module matcha.utils.array;

T[] initializedArray(T)(size_t n, T t)
in
{
	assert(n > 0);
}
out(result)
{
	foreach(T i; result)
	{
		assert(i == t);
	}
}
body
{
	T[] arr = new T[n];
	foreach(ref T i; arr)
	{
		i = t;
	}

	return arr;
}

