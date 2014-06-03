module matcha.math.matrix.matrix_operations;

import matcha.math.matrix.matrix;
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

Matrix!(T) add(T)(Matrix!(T) a, Matrix!(T) b)
in
{
	assert(a.rows == b.rows);
	assert(a.cols == b.cols);
	assert(a.channels == b.channels);
}
out(r)
{
	assert(a.rows == r.rows);
	assert(a.cols == r.cols);
	assert(a.channels == r.channels);
}
body
{
	auto r = initializedMatrix(a.rows, a.cols, a.channels, 0);

	T* a_ptr = a.data;
	T* b_ptr = b.data;
	const T* a_end_ptr = a.data + a.rows * a.cols * a.channels;
	T* r_ptr = r.data;

	while(a_ptr != a_end_ptr)
	{
		*(r_ptr++) = *(a_ptr++) + *(b_ptr++);
	}

	return r;
}

