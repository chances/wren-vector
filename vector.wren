/// Multi-dimensional vector with various operators.
///
/// Copyright:
/// Copyright © 2017 Freddie Ridell
/// Copyright © 2024 Chance Snow
/// License: MIT
/// See: https://github.com/FreddieRidell/wren-vector#readme

/// See: `Vector`
class Base {
  /// Number of elements in this `Vector`.
  arity { _arity }

  toString {
    if (_arity == 2) return "[%(this[0]), %(this[1])]"
    if (_arity == 3) return "[%(this[0]), %(this[1]), %(this[2])]"
    if (_arity == 4) return "[%(this[0]), %(this[1]), %(this[2]), %(this[3])]"
  }

  magnitude {
    var acc = 0
    for (i in 0..._arity) {
      acc = acc + (this[i] * this[i])
    }
    return acc.sqrt
  }

  /// Normalize this vector.
  normalize { this / this.magnitude }
  /// ditto
  normalized { this.normalize }
  /// ditto
  normalise { this.normalize }

  /// Computes the L2 (Euclidean) norm of a point.
  /// Returns: Num
  /// See: [Norm (mathematics): Euclidean norm](https://en.wikipedia.org/wiki/Norm_(mathematics)#Euclidean_norm) on Wikipedia
  norm {
    return _values.map {|n| n * n }.reduce(0) {|sum, x| sum + x }.sqrt
  }

  abs {
    var v = Base.ofArity(_arity)
    for (i in 0..._arity) {
      v[i] = this[i].abs
    }

    return v
  }

  floor {
    var v = Base.ofArity(_arity)
    for (i in 0..._arity) {
      v[i] = this[i].floor
    }

    return v
  }

  ceil {
    var v = Base.ofArity(_arity)
    for (i in 0..._arity) {
      v[i] = this[i].ceil
    }

    return v
  }

  inverse {
    var v = Base.ofArity(_arity)
    for (i in 0..._arity) {
      v[i] = -this[i]
    }
    return v
  }

  [ i ] {
    if (i == 0) {
      return _values[0]
    }
    if (i == 1) {
      return _values[1]
    }
    if (i == 2 && _arity > 2) {
      return _values[2]
    }
    if (i == 3 && _arity > 2) {
      return _values[3]
    }

    return null
  }

  [ i ]=(val) {
    if (i == 0) {
      _values[0] = val
    }
    if (i == 1) {
      _values[1] = val
    }
    if (i == 2 && _arity > 2) {
      _values[2] = val
    }
    if (i == 3 && _arity > 2) {
      _values[3] = val
    }

    return null
  }

  == (other) {
    if (_arity != other.arity) {
      Fiber.abort("ArgumentError: Can not compare vectors of un-equal arity.")
    }

    var acc = true
    for (i in 0..._arity) {
      acc = acc && this[i] == other[i]
    }
    return acc
  }

  + (other) {
    if (_arity != other.arity) {
      Fiber.abort("ArgumentError: Can not add vectors of un-equal arity.")
    }

    var v = Base.ofArity(_arity)
    for (i in 0..._arity) {
      v[i] = this[i] + other[i]
    }
    return v
  }

  - (other) {
    if (_arity != other.arity) {
      Fiber.abort("ArgumentError: Can not subtract vectors of un-equal arity.")
    }

    var v = Base.ofArity(_arity)
    for (i in 0..._arity) {
      v[i] = this[i] - other[i]
    }
    return v
  }

  * (other) {
    if (other is Vector) {
      if (_arity != other.arity) {
        Fiber.abort("ArgumentError: Can not divide vectors of un-equal arity.")
      }

      var v = Base.ofArity(_arity)
      for (i in 0..._arity) {
        v[i] = this[i] * other[i]
      }
      return v
    }

    if (other is Num) {
      var v = Base.ofArity(_arity)
      for (i in 0..._arity) {
        v[i] = this[i] * other
      }
      return v
    }

    Fiber.abort("ArgumentError: Can only multiply a Vector by a Num or another Vector.")
  }

  / (other) {
    if (other is Vector) {
      if (_arity != other.arity) {
        Fiber.abort("ArgumentError: Can not divide vectors of un-equal arity.")
      }

      var v = Base.ofArity(_arity)
      for (i in 0..._arity) {
        v[i] = this[i] / other[i]
      }
      return v
    }

    if (other is Num) {
      var v = Base.ofArity(_arity)
      for (i in 0..._arity) {
        v[i] = this[i] / other
      }
      return v
    }

    Fiber.abort("ArgumentError: Can only divide a Vector by a Num or another Vector.")
  }

  /// Calculate a dot product.
  /// Params: other: Vector
  /// Returns: Num
  dot(other) {
    if (_arity != other.arity) {
      Fiber.abort("ArgumentError: Can not dot product vectors of un-equal arity.")
    }

    var acc = 0
    for (i in 0..._arity) {
      acc = acc + (this[i] * other[i] )
    }

    return acc
  }

  /// Calculate a cross product.
  /// Params: other: Vector
  /// Returns: Vector
  cross(other) {
    if (_arity != 3) {
      Fiber.abort("ArgumentError: Can only cross product vectors of arity 3.")
    }

    var x = (this[1] * other[2]) - (this[2] * other[1])
    var y = (this[2] * other[0]) - (this[0] * other[2])
    var z = (this[0] * other[1]) - (this[1] * other[0])

    return Vector.new(x, y, z)
  }

  construct new(x, y) {
    _arity = 2
    _values = [x, y]
  }

  construct new(x, y, z) {
    _arity = 3
    _values = [x, y, z]
  }

  construct new(x, y, z, w) {
    _arity = 4
    _values = [x, y, z, w]
  }

  static ofArity(n) {
    if (n == 2) return Vector.new(0, 0)
    if (n == 3) return Vector.new(0, 0, 0)
    if (n == 4) return Vector.new(0, 0, 0, 0)
  }
}

class Vector is Base {
  x { this[0] }
  y { this[1] }
  z { this[2] }
  w { this[3] }

  x=(val) { this[0] = val }
  y=(val) { this[1] = val }
  z=(val) { this[2] = val }
  w=(val) { this[3] = val }

  construct new(x, y) {
    super(x, y)
  }

  construct new(x, y, z) {
    super(x, y, z)
  }

  construct new(x, y, z, w) {
    super(x, y, z, w)
  }

  /// Orthogonally rotate this 2D vector clockwise.
  /// Returns: Vector
  ///
  /// Warning:
  /// Descarte assumes a right-hand coordinate system.
  ///
  /// Positive angles are counter-clockwise if z-axis points offscreen.
  orthogonalRight {
    if (this.arity != 2) Fiber.abort("ArgumentError: Can only orthogonally rotate vector of arity 2.")
    return Vector.new(self.y, -self.x)
  }

  /// Orthogonally rotate this 2D vector counter-clockwise.
  /// Returns: Vector
  ///
  /// Warning:
  /// Descarte assumes a right-hand coordinate system.
  ///
  /// Positive angles are counter-clockwise if z-axis points offscreen.
  orthogonalLeft {
    if (this.arity != 2) Fiber.abort("ArgumentError: Can only orthogonally rotate vector of arity 2.")
    return this.inverse.orthogonalRight
  }

  /// Section: Angles
  /// Angle-related linear algebra.

  /// Params: other: Vector
  /// Returns: Num
  angleTo(other) {
    var theta = this.dot(other) / (this.norm * other.norm)
    return theta.min(1.0).max(-1.0).acos
  }

  /// Params:
  ///   direction: Vector
  ///   other: Vector
  /// Returns: Num
  angleAlongTo(direction, b) {
    var simpleAngle = this.angleTo(b)
    var linearDirection = (b - a).normalized

    if (direction.dot(linearDirection) >= 0) return simpleAngle
    return 2.0 * Num.pi - simpleAngle
  }

  /// Params: other: Vector
  /// Returns: Num
  signedAngleTo(other) {
    if (this.arity != 2) Fiber.abort("ArgumentError: Can only calculate a signed angle between vectors of arity 2.")
    // See https://stackoverflow.com/a/2150475
    var det = a.x * b.y - a.y * b.x
    var dot = a.x * b.x + a.y * b.y
    return det.atan(dot)
  }
}

/// A 4D color with red, green, blue, and alpha components.
class Color is Base {
  r { this[0] }
  g { this[1] }
  b { this[2] }
  a { this[3] }

  r=(val) { this[0] = val }
  g=(val) { this[1] = val }
  b=(val) { this[2] = val }
  a=(val) { this[3] = val }

  construct new(r, g, b) {
    super(r, g, b)
  }

  construct new(r, g, b, a) {
    super(r, g, b, a)
  }
}
