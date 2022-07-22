//
//  array.hpp
//  numpp
//
//  Created by Daniele Colombo on 17/06/2022.
//

#ifndef ndarray_hpp
#define ndarray_hpp

#include <cstddef>
#include <initializer_list>

#include "storage.hpp"
#include "utilities.hpp"


namespace npp {

using std::initializer_list;
using std::size_t;

template <typename T, typename Container = vector<T>>
class array {
  /* typedefs */
  using base_type = typename std::remove_pointer_t<T>;
  using pointer_type = typename std::add_pointer_t<base_type>;
  using pointer_type_const = typename std::add_pointer_t<base_type const>;
  using Container_noref = typename std::remove_reference_t<Container>;
  using Container_ref = typename std::add_lvalue_reference_t<Container_noref>;
  using Container_ref_const = typename std::add_lvalue_reference_t<Container_noref const>;

  /* member variables */
  Storage<T, Container> storage;

  /* helper functions */
  template <typename otherT, typename otherC>
  void checkSameDimensions(array<otherT, otherC> const& other) const;

  template <typename otherT, typename otherC>
  void checkDimensionsForDotProduct(array<otherT, otherC> const& other) const;

  template <typename oneT, typename oneC, typename twoT, typename twoC>
  base_type oneDotOne(array<oneT, oneC> const& one, array<twoT, twoC> const& two) const;
  template <typename otherT, typename otherC>
  array<base_type, Container_noref> oneDotTwo(array<T, Container> const& one,
                                              array<otherT, otherC> const& two) const;
  template <typename otherT, typename otherC>
  array<base_type, Container_noref> twoDotOne(array<T, Container> const& one,
                                              array<otherT, otherC> const& two) const;
  template <typename otherT, typename otherC>
  array<base_type, Container_noref> twoDotTwo(array<T, Container> const& one,
                                              array<otherT, otherC> const& two) const;

 public:
  /*
   * Trivial member functions
   */

  /* constructors */
  array() = default;
  explicit array(size_t capacity) : storage(capacity) {}
  array(nested_init_list_t<T, 1> l) : storage(l) {}
  array(nested_init_list_t<T, 2> l) : storage(l) {}
  array(nested_init_list_t<T, 3> l) : storage(l) {}
  array(nested_init_list_t<T, 4> l) : storage(l) {}
  array(nested_init_list_t<T, 5> l) : storage(l) {}
  array(nested_init_list_t<T, 6> l) : storage(l) {}
  array(nested_init_list_t<T, 7> l) : storage(l) {}
  explicit array(Storage<T, Container>& s) : storage(s) {}
  explicit array(Storage<T, Container>&& s) : storage(s) {}

  /* copy and move constructors*/
  array(array<T, Container_noref>& other) : storage(other.getStorage()) {}
  array(array<T, Container_ref>& other) : storage(other.getStorage()) {}
  array(array<T, Container_noref>&& other) : storage(other.getStorage()) {}
  array(array<T, Container_ref>&& other) : storage(other.getStorage()) {}

  /* copy and move assignments */
  array<T, Container>& operator=(array<T, Container> const& other) = default;
  array<T, Container>& operator=(array<T, Container>&& other) = default;

  /* getters */
  Shape<T> const& shape() const { return storage.shape(); }
  Storage<T, Container>& getStorage() { return storage; }

  /* object state inspectors */
  size_t size() const noexcept { return storage.size(); }

  /* indexing */
  base_type const& operator[](int i) const { return storage[i]; }
  base_type& operator[](int i) { return storage[i]; }

  template <class Arg, class... Args>
  base_type const& operator()(Arg arg, Args... args) const {
    return storage(arg, args...);
  }

  template <class Arg, class... Args>
  base_type& operator()(Arg arg, Args... args) {
    return storage(arg, args...);
  }

  /* view & copy */
  template <class Arg, class... Args>
  array<pointer_type, vector<pointer_type>> view(Arg arg, Args... args) {
    return array<pointer_type, vector<pointer_type>>(storage.view(arg, args...));
  }

  array<T, Container_ref> view() { return array<T, Container_ref>(storage.view()); }

  template <class Arg, class... Args>
  array<pointer_type_const, vector<pointer_type_const>> view(Arg arg, Args... args) const {
    return array<pointer_type_const, vector<pointer_type_const>>(storage.view(arg, args...));
  }

  array<T, Container_ref_const> view() const {
    return array<T, Container_ref_const>(storage.view());
  }

  array<base_type, vector<base_type>> copy() const {
    return array<base_type, vector<base_type>>(storage.copy());
  }

  /* reshape */
  array<T, Container_ref> reshape(initializer_list<size_t> l) {
    return array<T, Container_ref>(storage.reshape(l));
  }

  array<T, Container_ref> flatten() { return array<T, Container_ref>(storage.flatten()); }

  array<pointer_type, vector<pointer_type>> transpose() {
    return array<pointer_type, vector<pointer_type>>(storage.transpose());
  }

  void resize(initializer_list<size_t> l) { storage.resize(l); }

  void resize_flat() { storage.resize_flat(); }

  /*
   * Non-Trivial member functions
   */

  /* operators overloading */
  template <typename otherT, typename otherC>
  array<base_type, Container_noref> operator+(array<otherT, otherC> const& other) const;
  template <typename otherT, typename otherC>
  array<base_type, Container_noref> operator-(array<otherT, otherC> const& other) const;
  template <typename otherT, typename otherC>
  array<base_type, Container_noref> operator*(array<otherT, otherC> const& other) const;
  template <typename otherT, typename otherC>
  array<base_type, Container_noref> operator/(array<otherT, otherC> const& other) const;
  template <typename otherT, typename otherC>
  array<base_type, Container_noref> operator%(array<otherT, otherC> const& other) const;

  template <typename otherT, typename otherC>
  array<char> operator==(array<otherT, otherC> const& other) const;
  template <typename otherT, typename otherC>
  array<char> operator>(array<otherT, otherC> const& other) const;
  template <typename otherT, typename otherC>
  array<char> operator>=(array<otherT, otherC> const& other) const;
  template <typename otherT, typename otherC>
  array<char> operator<(array<otherT, otherC> const& other) const;
  template <typename otherT, typename otherC>
  array<char> operator<=(array<otherT, otherC> const& other) const;

  template <typename otherT>
  array<base_type, Container_noref> operator+(otherT element) const;
  template <typename otherT>
  array<base_type, Container_noref> operator-(otherT element) const;
  template <typename otherT>
  array<base_type, Container_noref> operator*(otherT element) const;
  template <typename otherT>
  array<base_type, Container_noref> operator/(otherT element) const;
  template <typename otherT>
  array<base_type, Container_noref> operator%(otherT element) const;

  template <typename otherT>
  array<char> operator==(otherT element) const;
  template <typename otherT>
  array<char> operator>(otherT element) const;
  template <typename otherT>
  array<char> operator>=(otherT element) const;
  template <typename otherT>
  array<char> operator<(otherT element) const;
  template <typename otherT>
  array<char> operator<=(otherT element) const;

  /* any() and all() */
  bool any() const;
  bool all() const;

  /* dot product */
  template <typename otherT, typename otherC>
  array<base_type, Container_noref> dot(array<otherT, otherC> const& other) const;
};

/*************************
 * IMPLEMENTATION
 **************************/
/* helper functions */
template <typename T, typename Container>
template <typename otherT, typename otherC>
inline void array<T, Container>::checkSameDimensions(array<otherT, otherC> const& other) const {
  if (!(shape() == other.shape())) {
    throw DimensionsMismatchError(shape().getShape(), other.shape().getShape());
  }
}

template <typename T, typename Container>
template <typename otherT, typename otherC>
inline void array<T, Container>::checkDimensionsForDotProduct(
    array<otherT, otherC> const& other) const {
  auto const dims = shape().ndims();
  auto const o_dims = other.shape().ndims();
  auto const s = shape();
  auto const o_s = other.shape();

  if (dims > 2 || o_dims > 2)  // dot product defined only for 1 or 2 dimensions matrices
    throw DimensionsMismatchError(shape().getShape(), other.shape().getShape());

  if (dims == 1 && o_dims == 1) {
    if (s[0] != o_s[0]) throw DimensionsMismatchError(s.getShape(), o_s.getShape());
  } else if (dims == 1 && o_dims == 2) {
    if (s[0] != o_s[0]) throw DimensionsMismatchError(s.getShape(), o_s.getShape());
  } else if (dims == 2 && o_dims == 1) {
    if (s[1] != o_s[0]) throw DimensionsMismatchError(s.getShape(), o_s.getShape());
  } else if (dims == 2 && o_dims == 2) {
    if (s[1] != o_s[0]) throw DimensionsMismatchError(s.getShape(), o_s.getShape());
  }
}

/* operators overloading */

template <typename T, typename Container>
template <typename otherT, typename otherC>
inline auto array<T, Container>::operator+(array<otherT, otherC> const& other) const
    -> array<base_type, Container_noref> {
  // check shapes are the same
  checkSameDimensions(other);
  // compute and return result
  array<base_type, Container_noref> result(shape());
  for (auto i = 0; i < size(); i++) {
    result[i] = (*this)[i] + other[i];
  }
  return result;
}

template <typename T, typename Container>
template <typename otherT, typename otherC>
inline auto array<T, Container>::operator-(array<otherT, otherC> const& other) const
    -> array<base_type, Container_noref> {
  // check shapes are the same
  checkSameDimensions(other);
  // compute and return result
  array<base_type, Container_noref> result(shape());
  for (auto i = 0; i < size(); i++) {
    result[i] = (*this)[i] - other[i];
  }
  return result;
}

template <typename T, typename Container>
template <typename otherT, typename otherC>
inline auto array<T, Container>::operator*(array<otherT, otherC> const& other) const
    -> array<base_type, Container_noref> {
  // check shapes are the same
  checkSameDimensions(other);
  // compute and return result
  array<base_type, Container_noref> result(shape());
  for (auto i = 0; i < size(); i++) {
    result[i] = (*this)[i] * other[i];
  }
  return result;
}

template <typename T, typename Container>
template <typename otherT, typename otherC>
inline auto array<T, Container>::operator/(array<otherT, otherC> const& other) const
    -> array<base_type, Container_noref> {
  // check shapes are the same
  checkSameDimensions(other);
  // compute and return result
  array<base_type, Container_noref> result(shape());
  for (auto i = 0; i < size(); i++) {
    result[i] = (*this)[i] / other[i];
  }
  return result;
}

template <typename T, typename Container>
template <typename otherT, typename otherC>
inline auto array<T, Container>::operator%(array<otherT, otherC> const& other) const
    -> array<base_type, Container_noref> {
  // check shapes are the same
  checkSameDimensions(other);
  // compute and return result
  array<base_type, Container_noref> result(shape());
  for (auto i = 0; i < size(); i++) {
    result[i] = (*this)[i] % other[i];
  }
  return result;
}

template <typename T, typename Container>
template <typename otherT, typename otherC>
inline auto array<T, Container>::operator==(array<otherT, otherC> const& other) const
    -> array<char> {
  // check shapes are the same
  checkSameDimensions(other);
  // compute and return result
  array<char> result(shape());
  for (auto i = 0; i < size(); i++) {
    result[i] = (*this)[i] == other[i];
  }
  return result;
}

template <typename T, typename Container>
template <typename otherT, typename otherC>
inline auto array<T, Container>::operator>(array<otherT, otherC> const& other) const
    -> array<char> {
  // check shapes are the same
  checkSameDimensions(other);
  // compute and return result
  array<char> result(shape());
  for (auto i = 0; i < size(); i++) {
    result[i] = (*this)[i] > other[i];
  }
  return result;
}

template <typename T, typename Container>
template <typename otherT, typename otherC>
inline auto array<T, Container>::operator>=(array<otherT, otherC> const& other) const
    -> array<char> {
  // check shapes are the same
  checkSameDimensions(other);
  // compute and return result
  array<char> result(shape());
  for (auto i = 0; i < size(); i++) {
    result[i] = (*this)[i] >= other[i];
  }
  return result;
}

template <typename T, typename Container>
template <typename otherT, typename otherC>
inline auto array<T, Container>::operator<(array<otherT, otherC> const& other) const
    -> array<char> {
  // check shapes are the same
  checkSameDimensions(other);
  // compute and return result
  array<char> result(shape());
  for (auto i = 0; i < size(); i++) {
    result[i] = (*this)[i] < other[i];
  }
  return result;
}

template <typename T, typename Container>
template <typename otherT, typename otherC>
inline auto array<T, Container>::operator<=(array<otherT, otherC> const& other) const
    -> array<char> {
  // check shapes are the same
  checkSameDimensions(other);
  // compute and return result
  array<char> result(shape());
  for (auto i = 0; i < size(); i++) {
    result[i] = (*this)[i] <= other[i];
  }
  return result;
}

template <typename T, typename Container>
template <typename otherT>
inline auto array<T, Container>::operator+(otherT element) const
    -> array<base_type, Container_noref> {
  array<base_type, Container_noref> result(shape());
  for (auto i = 0; i < size(); i++) {
    result[i] = (*this)[i] + element;
  }
  return result;
}

template <typename T, typename Container>
template <typename otherT>
inline auto array<T, Container>::operator-(otherT element) const
    -> array<base_type, Container_noref> {
  array<base_type, Container_noref> result(shape());
  for (auto i = 0; i < size(); i++) {
    result[i] = (*this)[i] - element;
  }
  return result;
}

template <typename T, typename Container>
template <typename otherT>
inline auto array<T, Container>::operator*(otherT element) const
    -> array<base_type, Container_noref> {
  array<base_type, Container_noref> result(shape());
  for (auto i = 0; i < size(); i++) {
    result[i] = (*this)[i] * element;
  }
  return result;
}

template <typename T, typename Container>
template <typename otherT>
inline auto array<T, Container>::operator/(otherT element) const
    -> array<base_type, Container_noref> {
  array<base_type, Container_noref> result(shape());
  for (auto i = 0; i < size(); i++) {
    result[i] = (*this)[i] / element;
  }
  return result;
}

template <typename T, typename Container>
template <typename otherT>
inline auto array<T, Container>::operator%(otherT element) const
    -> array<base_type, Container_noref> {
  array<base_type, Container_noref> result(shape());
  for (auto i = 0; i < size(); i++) {
    result[i] = (*this)[i] % element;
  }
  return result;
}

template <typename T, typename Container>
template <typename otherT>
inline auto array<T, Container>::operator==(otherT element) const -> array<char> {
  array<char> result(shape());
  for (auto i = 0; i < size(); i++) {
    result[i] = (*this)[i] == element;
  }
  return result;
}

template <typename T, typename Container>
template <typename otherT>
inline auto array<T, Container>::operator>(otherT element) const -> array<char> {
  array<char> result(shape());
  for (auto i = 0; i < size(); i++) {
    result[i] = (*this)[i] > element;
  }
  return result;
}

template <typename T, typename Container>
template <typename otherT>
inline auto array<T, Container>::operator>=(otherT element) const -> array<char> {
  array<char> result(shape());
  for (auto i = 0; i < size(); i++) {
    result[i] = (*this)[i] >= element;
  }
  return result;
}

template <typename T, typename Container>
template <typename otherT>
inline auto array<T, Container>::operator<(otherT element) const -> array<char> {
  array<char> result(shape());
  for (auto i = 0; i < size(); i++) {
    result[i] = (*this)[i] < element;
  }
  return result;
}

template <typename T, typename Container>
template <typename otherT>
inline auto array<T, Container>::operator<=(otherT element) const -> array<char> {
  array<char> result(shape());
  for (auto i = 0; i < size(); i++) {
    result[i] = (*this)[i] <= element;
  }
  return result;
}

/* any() and all() */
template <typename T, typename Container>
inline bool array<T, Container>::any() const {
  for (auto i = 0; i < size(); i++) {
    if ((*this)[i]) return true;
  }
  return false;
}

template <typename T, typename Container>
inline bool array<T, Container>::all() const {
  for (auto i = 0; i < size(); i++) {
    if (!(*this)[i]) return false;
  }
  return true;
}

/* dot product */
template <typename T, typename Container>
template <typename otherT, typename otherC>
inline auto array<T, Container>::dot(array<otherT, otherC> const& other) const
    -> array<base_type, Container_noref> {
  // perform dimensions checking
  checkDimensionsForDotProduct(other);

  auto dims = shape().ndims();
  auto o_dims = other.shape().ndims();
  if (dims == 1 && o_dims == 1) return {oneDotOne(*this, other)};
  if (dims == 2 && o_dims == 1) return twoDotOne(*this, other);
  if (dims == 1 && o_dims == 2) return oneDotTwo(*this, other);
  // if (dims == 2 && o_dims == 2)
  return twoDotTwo(*this, other);
}

template <typename T, typename Container>
template <typename oneT, typename oneC, typename twoT, typename twoC>
inline auto array<T, Container>::oneDotOne(array<oneT, oneC> const& one,
                                           array<twoT, twoC> const& two) const -> base_type {
  base_type result = 0;
  for (auto i = 0u; i < one.size(); i++) {
    result += one[i] * two[i];
  }
  return result;
}

template <typename T, typename Container>
template <typename otherT, typename otherC>
inline auto array<T, Container>::oneDotTwo(array<T, Container> const& one,
                                           array<otherT, otherC> const& two) const
    -> array<base_type, Container_noref> {
  auto const size = two.shape()[1];
  array<base_type, Container_noref> result(size);
  for (auto col = 0u; col < size; col++) {
    result(col) = oneDotOne(one, two.view(npp::all(), col));
  }
  return result;
}

template <typename T, typename Container>
template <typename otherT, typename otherC>
inline auto array<T, Container>::twoDotOne(array<T, Container> const& one,
                                           array<otherT, otherC> const& two) const
    -> array<base_type, Container_noref> {
  auto const size = one.shape()[0];
  array<base_type, Container_noref> result(size);
  for (auto row = 0u; row < size; row++) {
    result(row) = oneDotOne(one.view(row, npp::all()), two);
  }
  return result;
}

template <typename T, typename Container>
template <typename otherT, typename otherC>
inline auto array<T, Container>::twoDotTwo(array<T, Container> const& one,
                                           array<otherT, otherC> const& two) const
    -> array<base_type, Container_noref> {
  auto const rows = one.shape()[0];
  auto const cols = two.shape()[1];
  auto const size = rows * cols;
  array<base_type, Container_noref> result(size);
  result.resize({rows, cols});
  for (auto row = 0u; row < rows; row++) {
    for (auto col = 0u; col < cols; col++)
      result(row, col) = oneDotOne(one.view(row, npp::all()), two.view(npp::all(), col));
  }
  return result;
}

}  // namespace npp

#endif /* ndarray_hpp */
