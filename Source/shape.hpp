//
//  shape.hpp
//  numpp
//
//  Created by Daniele Colombo on 06/07/2022.
//

#ifndef shape_h
#define shape_h

#include <cstddef>
#include <initializer_list>
#include <utility>
#include <vector>

#include "exceptions.hpp"
#include "utilities.hpp"

namespace npp {
using std::initializer_list;
using std::size_t;
using std::vector;

/***********************************
 * SHAPE DEFINITION
 ************************************/

template <typename T = int>
class Shape {
  /* member variables */
  vector<size_t> shape{};
  DimensionsChecker<T> checker{};

  /* helper functions*/
  template <size_t I>
  void fillShape(nested_init_list_t<T, I> l);

  template <>
  void fillShape<1>(nested_init_list_t<T, 1> l) {
    shape.push_back(l.size());
  }

 public:
  /* constructors */
  Shape() = default;
  template <typename Arg, typename... Args>
  Shape(Arg arg, Args... args) : shape({static_cast<size_t>(arg), static_cast<size_t>(args)...}) {}
  Shape(initializer_list<T> l) : shape({l.size()}) {}
  Shape(nested_init_list_t<T, 2> l);
  Shape(nested_init_list_t<T, 3> l);
  Shape(nested_init_list_t<T, 4> l);
  Shape(nested_init_list_t<T, 5> l);
  Shape(nested_init_list_t<T, 6> l);
  Shape(nested_init_list_t<T, 7> l);

  Shape(vector<size_t> const& shape) : shape(shape) {}
  Shape(vector<size_t>&& shape) : shape(shape) {}

  /* copy and move constructors */
  template <typename otherT>
  Shape(Shape<otherT> const& other) : shape(other.getShape()) {}
  template <typename otherT>
  Shape(Shape<otherT>&& other) : shape(std::move(other.getShape())) {}

  /* copy and move assignments */
  template <typename otherT>
  Shape<T>& operator=(Shape<otherT> const& other);
  template <typename otherT>
  Shape<T>& operator=(Shape<otherT>&& other);

  /* assignment operator overloading */
  Shape<T>& operator=(vector<size_t> const& otherShape);
  Shape<T>& operator=(vector<size_t>&& otherShape);

  /* comparison operator overloading */
  template <typename oneT, typename twoT>
  friend bool operator==(Shape<oneT> const& one, Shape<twoT> const& two);

  /* getters */
  vector<size_t> const& getShape() const { return shape; }
  DimensionsChecker<T> const& getChecker() const { return checker; }

  /* other functions */
  size_t ndims() const { return shape.size(); }
  size_t operator[](size_t i) const { return shape[i]; }
  size_t calc_size() const;
  template <typename otherT>
  bool is_equivalent(Shape<otherT> const& other) const;
};

/***********************************
 * STRIDES DEFINITION
 ************************************/

class Strides {
  vector<size_t> strides{};

 public:
  /* constructors */
  Strides() = default;
  template <typename T>
  Strides(Shape<T> shape);

  /* copy and move constructors */
  Strides(Strides const& other) : strides(other.strides) {}
  Strides(Strides&& other) : strides(std::move(other.strides)) {}

  /* copy and move assignments */
  Strides& operator=(Strides const& other);
  Strides& operator=(Strides&& other);

  /* other functions */
  size_t ndims() const { return strides.size(); }
  size_t operator[](size_t i) const { return strides[i]; }

  template <typename T>
  void fromShape(Shape<T> const& shape);
};

/***********************************
 * SHAPE IMPLEMENTATION
 ************************************/

/* constructors */
template <typename T>
inline Shape<T>::Shape(nested_init_list_t<T, 2> l) {
  checker.template checkNestedInitList<2>(l);
  shape.reserve(2);
  fillShape<2>(l);
}
template <typename T>
inline Shape<T>::Shape(nested_init_list_t<T, 3> l) {
  checker.template checkNestedInitList<3>(l);
  shape.reserve(3);
  fillShape<3>(l);
}
template <typename T>
inline Shape<T>::Shape(nested_init_list_t<T, 4> l) {
  checker.template checkNestedInitList<4>(l);
  shape.reserve(4);
  fillShape<4>(l);
}
template <typename T>
inline Shape<T>::Shape(nested_init_list_t<T, 5> l) {
  checker.template checkNestedInitList<5>(l);
  shape.reserve(5);
  fillShape<5>(l);
}
template <typename T>
inline Shape<T>::Shape(nested_init_list_t<T, 6> l) {
  checker.template checkNestedInitList<6>(l);
  shape.reserve(6);
  fillShape<6>(l);
}
template <typename T>
inline Shape<T>::Shape(nested_init_list_t<T, 7> l) {
  checker.template checkNestedInitList<7>(l);
  shape.reserve(7);
  fillShape<7>(l);
}

/* copy and move assignments */
template <typename T>
template <typename otherT>
inline Shape<T>& Shape<T>::operator=(Shape<otherT> const& other) {
  shape = other.getShape();
  return *this;
}
template <typename T>
template <typename otherT>
inline Shape<T>& Shape<T>::operator=(Shape<otherT>&& other) {
  shape = std::move(other.getShape());
  return *this;
}

/* assignment operator overloading */
template <typename T>
inline Shape<T>& Shape<T>::operator=(vector<size_t> const& otherShape) {
  shape = otherShape;
  return *this;
}

template <typename T>
inline Shape<T>& Shape<T>::operator=(vector<size_t>&& otherShape) {
  shape = otherShape;
  return *this;
}

/* comparison operator overloading */
template <typename oneT, typename twoT>
inline bool operator==(Shape<oneT> const& one, Shape<twoT> const& two) {
  // check same number of dimensions
  if (one.getShape().size() != two.getShape().size()) return false;
  // check same size in each dimension
  for (auto i = 0u; i < one.getShape().size(); i++) {
    if (one.getShape()[i] != two.getShape()[i]) return false;
  }
  // otherwise return true
  return true;
}

/* helper functions*/
template <typename T>
template <size_t I>
inline void Shape<T>::fillShape(nested_init_list_t<T, I> l) {
  shape.push_back(l.size());
  fillShape<I - 1>(*l.begin());
}

/* other functions */
template <typename T>
inline size_t Shape<T>::calc_size() const {
  if (ndims() == 0) {
    return 0;
  }
  size_t size = 1;
  for (auto dim : shape) {
    size *= dim;
  }

  return size;
}

template <typename T>
template <typename otherT>
inline bool Shape<T>::is_equivalent(Shape<otherT> const& other) const {
  return calc_size() == other.calc_size();
}

/*************************************
 * STRIDES IMPLEMENTATION
 **************************************/

/* constructors */
template <typename T>
inline Strides::Strides(Shape<T> shape) {
  fromShape<T>(shape);
}

/* copy and move assignments */
inline Strides& Strides::operator=(Strides const& other) {
  strides = other.strides;
  return *this;
}
inline Strides& Strides::operator=(Strides&& other) {
  strides = std::move(other.strides);
  return *this;
}

/* helper function */
template <typename T>
void Strides::fromShape(Shape<T> const& shape) {
  size_t ndims = shape.ndims();
  vector<size_t> vec(ndims);

  for (size_t i = 1, cumul = 1; i <= ndims; i++) {
    size_t idx = ndims - i;
    vec[idx] = cumul;
    cumul *= shape[idx];
  }

  strides = std::move(vec);
}

}  // namespace npp

#endif /* shape_h */
