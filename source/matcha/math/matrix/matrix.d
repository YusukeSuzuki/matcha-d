module matcha.math.matrix.matrix;

import matcha.utils.array;

import std.algorithm;
import std.stdint;
import std.c.string;

import core.memory;

class Matrix(T)
{
	this(uintmax_t rows, uintmax_t cols, uintmax_t channels)
	in
	{
		assert(rows != 0 && cols != 0 && channels != 0);
	}
	body
	{
		this.m_rows = rows;
		this.m_cols = cols;
		this.m_channels = channels;

		data = cast(T*)( GC.malloc(typeid(T).tsize * rows * cols * channels) );
	}

	this(uintmax_t rows, uintmax_t cols)
	in
	{
		assert(rows != 0 && cols != 0);
	}
	body
	{
		this(rows, cols, 1);
	}

	~this()
	{
	}

	Matrix!(T) dup() const
	{
		auto result = new Matrix!(T)(this.rows, this.cols, this.channels);
		memcpy(result.data, this.data, typeid(T).tsize * rows * cols * channels);
		return result;
	}

	@property auto rows() const { return m_rows; }
	@property auto cols() const { return m_cols; }
	@property auto channels() const { return m_channels; }

	@property auto totalOfElements() const { return m_rows * m_cols * m_channels; }

	ref T opIndex(size_t i1)
		in { assert(i1 < totalOfElements); }
		body { return data[i1]; }

	T opIndex(size_t i1) const
		in { assert(i1 < totalOfElements); }
		body { return data[i1]; }

	ref T opIndex(size_t i1, size_t i2, size_t i3 = 0)
		in { assert(i1 < m_rows && i2 < m_cols && i3 < m_channels); }
		body { return data[i1 * m_cols * m_channels + i2 * m_channels + i3]; }

	T opIndex(size_t i1, size_t i2, size_t i3 = 0) const
		in { assert(i1 < m_rows && i2 < m_cols && i3 < m_channels); }
		body { return data[i1 * m_cols * m_channels + i2 * m_channels + i3]; }

	package uintmax_t m_rows;
	package uintmax_t m_cols;
	package uintmax_t m_channels;

	package T* data;

	@disable this() { assert(false); }
}

