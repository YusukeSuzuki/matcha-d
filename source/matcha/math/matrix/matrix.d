import matcha.utils.array;

import std.algorithm;
import std.stdint;
import std.c.string;

import core.memory;

class Matrix(T)
{
	this(uintmax_t rows, uintmax_t cols, uintmax_t channels)
	{
		this.m_rows = rows;
		this.m_cols = cols;
		this.m_channels = channels;

		data = cast(T*)( GC.malloc(typeid(T).tsize * rows * cols * channels) );
	}

	this(uintmax_t rows, uintmax_t cols)
	{
		this(rows, cols, 1);
	}

	~this()
	{
		//GC.free(data);
	}

	Matrix!(T) dup()
	{
		auto result = Matrix!(T)(this.rows, this.cols, this.channels);
		memcpy(result.data, this.data, typeid(T).tsize * rows * cols * channels);
		return result;
	}

	@property auto rows() const { return m_rows; }
	@property auto cols() const { return m_cols; }
	@property auto channels() const { return m_channels; }

	private uintmax_t m_rows;
	private uintmax_t m_cols;
	private uintmax_t m_channels;

	T* data;

	private this() { assert(false); }
}

