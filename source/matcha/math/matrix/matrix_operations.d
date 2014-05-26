import matrix;

import matcha.utils.array;

import std.stdint;

Matrix!(T) initializedMatrix(T)(
	uintmax_t rows, uintmax_t cols, uintmax_t channels, T val)
{
	auto result = new Matrix!(T)(rows, cols, channels);

	T* ptr = result.data;
	const T* end_ptr = ptr + (rows * cols * channels);

	while(ptr != end_ptr)
	{
		*ptr = val;
		++ptr;
	}

	return result;
}

real[] sum(T)(in Matrix!(T) m)
in
{
	assert(m.channels > 0);
}
out(result)
{
	assert(result.length == m.channels);
}
body
{
	real[] result = initializedArray!(real)(m.channels, 0);

	const uintmax_t elems = m.rows * m.cols * m.channels;

	for(uintmax_t i = 0; i < elems; i += m.channels)
	{
		foreach(int j, ref real r; result)
		{
			r += m.data[i+j];
		}
	}

	return result;
}

