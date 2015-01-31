module matcha.math.matrix.matrix_operations;

import matcha.math.matrix.matrix;
import matcha.utils.array;

import std.stdint;

unittest { import std.stdio; writeln(__MODULE__, " : test start"); }

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

	const uintmax_t elems = m.totalOfElements;

	for(uintmax_t i = 0; i < elems; i += m.channels)
	{
		foreach(int j, ref real r; result)
		{
			r += m.data[i+j];
		}
	}

	return result;
}

Matrix!(T) add(T)(in Matrix!(T) a, in Matrix!(T) b)
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
	T* r_ptr = r.data;

	const(T)* a_ptr = a.data;
	const(T)* b_ptr = b.data;
	const auto a_end_ptr = a.data + a.totalOfElements;

	while(a_ptr != a_end_ptr)
	{
		*(r_ptr++) = *(a_ptr++) + *(b_ptr++);
	}

	return r;
}

unittest
{
}

Matrix!(T) add(T)(in Matrix!(T) a, in T b)
out(r)
{
	assert(a.rows == r.rows);
	assert(a.cols == r.cols);
	assert(a.channels == r.channels);
}
body
{
	auto r = a.dup();
	T* r_ptr = r.data;
	const T* r_end_ptr = r.data + r.totalOfElements;

	while(r_ptr != r_end_ptr)
	{
		*r_ptr += b;
		++r_ptr;
	}

	return r;
}

Matrix!(T) mul(T)(in Matrix!(T) a, in T b)
out(r)
{
	assert(a.rows == r.rows);
	assert(a.cols == r.cols);
	assert(a.channels == r.channels);
}
body
{
	auto r = a.dup;

	T* r_ptr = r.data;
	const T* r_end_ptr = r.data + r.totalOfElements;

	while(r_ptr != r_end_ptr)
	{
		*r_ptr *= b;
		++r_ptr;
	}
}

Matrix!(T) div(T)(in Matrix!(T) a, in T b)
in
{
	assert(b != 0);
}
out(r)
{
	assert(a.rows == r.rows);
	assert(a.cols == r.cols);
	assert(a.channels == r.channels);
}
body
{
	auto r = a.dup;

	T* r_ptr = r.data;
	const T* r_end_ptr = r.data + r.totalOfElements;

	while(r_ptr != r_end_ptr)
	{
		*r_ptr /= b;
		++r_ptr;
	}
}

unittest
{
	const real a = 1.0;
	const real b = 2.0;

	auto c = initializedMatrix!(real)(2,2,1,a);
	auto d = add(c, b);

	auto d_ptr = d.data;
	const auto d_end_ptr = d.data + d.totalOfElements;

	while(d_ptr != d_end_ptr)
	{
		assert(*d_ptr == a + b);
		++d_ptr;
	}
}

unittest { import std.stdio; writeln(__MODULE__, " : test clear"); }

