//
//  storage.hpp
//  numpp
//
//  Created by Daniele Colombo on 24/06/2022.
//

#ifndef storage_hpp
#define storage_hpp

#include <cstddef>
#include <initializer_list>
#include <type_traits>
#include <utility>
#include <vector>

#include "shape.hpp"
#include "utilities.hpp"

namespace npp {

using std::initializer_list;
using std::size_t;
using std::vector;

/*********************
 * DEFINITION
 *********************/

/* Container should be std::vector or std::vector & */
template <typename T, typename Container = vector<T>>
class Storage {
  /* typedefs */
  using base_type = typename std::remove_pointer_t<T>;
  using pointer_type = typename std::add_pointer_t<base_type>;
  using Container_noref = typename std::remove_reference_t<Container>;
  using Container_ref = typename std::add_lvalue_reference_t<Container_noref>;
  using Container_ref_const = typename std::add_lvalue_reference_t<Container_noref const>;
  using iterator = typename Container_noref::iterator;
  using const_iterator = typename Container_noref::const_iterator;

  /* member variables */
  Container data{};
  Shape<T> shape_{};
  Strides strides_{};

  /* helper functions */
  bool out_of_bound(int i);
  base_type& getElement(size_t i, vector<base_type>& vec);
  base_type& getElement(size_t i, vector<pointer_type>& vec);
  base_type const& getElement(size_t i, vector<base_type> const& vec) const;
  base_type const& getElement(size_t i, vector<pointer_type> const& vec) const;

  void fillStorage(base_type const& element);
  void fillStorage(pointer_type const& element);
  template <typename S>
  void fillStorage(std::initializer_list<S> l);

  template <size_t dim, class Arg, class... Args>
  size_t getIndex(Arg arg, Args... args) const;
  template <size_t dim>
  size_t getIndex() const;

 public:
  /* constructors */
  Storage() = default;
  explicit Storage(size_t capacity);
  Storage(nested_init_list_t<T, 1> l);
  Storage(nested_init_list_t<T, 2> l);
  Storage(nested_init_list_t<T, 3> l);
  Storage(nested_init_list_t<T, 4> l);
  Storage(nested_init_list_t<T, 5> l);
  Storage(nested_init_list_t<T, 6> l);
  Storage(nested_init_list_t<T, 7> l);
  Storage(Container_ref c);
  Storage(Container_ref c, Shape<T> newShape);

  /* copy and move constructors*/
  Storage(Storage<T, Container_noref>& other);
  Storage(Storage<T, Container_ref>& other);
  Storage(Storage<T, Container_noref>&& other);
  Storage(Storage<T, Container_ref>&& other);

  /* copy and move assignments */
  Storage<T, Container>& operator=(Storage<T, Container> const& other) = default;
  Storage<T, Container>& operator=(Storage<T, Container>&& other) = default;

  /* getters */
  Container_ref getData() { return data; }
  Container_ref_const getData() const { return data; }
  Shape<T> const& shape() const { return shape_; }
  Strides const& strides() const { return strides_; }

  /* object state inspectors */
  constexpr size_t size() const noexcept { return data.size(); }
  constexpr size_t capacity() const noexcept { return data.capacity(); }

  /* indexing and iterators */
  base_type const& operator[](int i) const;
  base_type& operator[](int i);

  template <class Arg, class... Args>
  base_type const& operator()(Arg arg, Args... args) const;
  template <class Arg, class... Args>
  base_type& operator()(Arg arg, Args... args);

  iterator begin() { return data.begin(); }
  const_iterator cbegin() { return data.cbegin(); }
  iterator end() { return data.end(); }
  const_iterator cend() { return data.cend(); }

  /* reshape */
  Storage<T, Container_ref> reshape(initializer_list<size_t> l);
  Storage<T, Container_ref> flatten();
  void resize(initializer_list<size_t> l);
  void resize_flat();
};

/*************************
 * IMPLEMENTATION
 **************************/

/* constructors */

template <typename T, typename Container>
inline Storage<T, Container>::Storage(size_t capacity) : shape_(capacity), strides_(shape_) {
  data.reserve(capacity);
}

template <typename T, typename Container>
inline Storage<T, Container>::Storage(nested_init_list_t<T, 1> l)
    : data(l), shape_(l), strides_(shape_) {}

template <typename T, typename Container>
inline Storage<T, Container>::Storage(nested_init_list_t<T, 2> l) : shape_(l), strides_(shape_) {
  data.reserve(shape().calc_size());
  fillStorage(l);
}

template <typename T, typename Container>
inline Storage<T, Container>::Storage(nested_init_list_t<T, 3> l) : shape_(l), strides_(shape_) {
  data.reserve(shape().calc_size());
  fillStorage(l);
}

template <typename T, typename Container>
inline Storage<T, Container>::Storage(nested_init_list_t<T, 4> l) : shape_(l), strides_(shape_) {
  data.reserve(shape().calc_size());
  fillStorage(l);
}
template <typename T, typename Container>
inline Storage<T, Container>::Storage(nested_init_list_t<T, 5> l) : shape_(l), strides_(shape_) {
  data.reserve(shape().calc_size());
  fillStorage(l);
}
template <typename T, typename Container>
inline Storage<T, Container>::Storage(nested_init_list_t<T, 6> l) : shape_(l), strides_(shape_) {
  data.reserve(shape().calc_size());
  fillStorage(l);
}
template <typename T, typename Container>
inline Storage<T, Container>::Storage(nested_init_list_t<T, 7> l) : shape_(l), strides_(shape_) {
  data.reserve(shape().calc_size());
  fillStorage(l);
}

template <typename T, typename Container>
inline Storage<T, Container>::Storage(Container_ref c)
    : data(c), shape_(capacity()), strides_(shape_) {}

template <typename T, typename Container>
inline Storage<T, Container>::Storage(Container_ref c, Shape<T> newShape)
    : data(c), shape_(newShape), strides_(newShape) {}

/* copy and move constructors*/
template <typename T, typename Container>
inline Storage<T, Container>::Storage(Storage<T, Container_noref>& other)
    : data(other.getData()), shape_(other.shape()), strides_(other.strides()) {}

template <typename T, typename Container>
inline Storage<T, Container>::Storage(Storage<T, Container_ref>& other)
    : data(other.getData()), shape_(other.shape()), strides_(other.strides()) {}

template <typename T, typename Container>
inline Storage<T, Container>::Storage(Storage<T, Container_noref>&& other)
    : data(std::move(other.getData())),
      shape_(std::move(other.shape())),
      strides_(std::move(other.strides())) {}

template <typename T, typename Container>
inline Storage<T, Container>::Storage(Storage<T, Container_ref>&& other)
    : data(other.getData()),
      shape_(std::move(other.shape())),
      strides_(std::move(other.strides())) {}

/* helper functions */

template <typename T, typename Container>
inline bool Storage<T, Container>::out_of_bound(int i) {
  if (i < 0) {
    return static_cast<size_t>(-i) >= size();
  }
  return static_cast<size_t>(i) >= size();
}

template <typename T, typename Container>
inline auto Storage<T, Container>::getElement(size_t i, vector<base_type>& vec) -> base_type& {
  return vec[i];
}

template <typename T, typename Container>
inline auto Storage<T, Container>::getElement(size_t i, vector<pointer_type>& vec) -> base_type& {
  return *vec[i];
}

template <typename T, typename Container>
inline auto Storage<T, Container>::getElement(size_t i, vector<base_type> const& vec) const
    -> base_type const& {
  return vec[i];
}

template <typename T, typename Container>
inline auto Storage<T, Container>::getElement(size_t i, vector<pointer_type> const& vec) const
    -> base_type const& {
  return *vec[i];
}

template <typename T, typename Container>
inline void Storage<T, Container>::fillStorage(base_type const& element) {
  data.push_back(element);
}

template <typename T, typename Container>
inline void Storage<T, Container>::fillStorage(pointer_type const& element) {
  data.push_back(element);
}

template <typename T, typename Container>
template <typename S>
inline void Storage<T, Container>::fillStorage(std::initializer_list<S> l) {
  for (auto it = l.begin(); it != l.end(); ++it) {
    fillStorage(*it);
  }
}

template <typename T, typename Container>
template <size_t dim, class Arg, class... Args>
inline size_t Storage<T, Container>::getIndex(Arg arg, Args... args) const {
  if (arg < 0) {
    arg = static_cast<int>(shape_[dim]) + arg;
  }
  return strides_[dim] * static_cast<size_t>(arg) + getIndex<dim + 1>(args...);
}

template <typename T, typename Container>
template <size_t dim>
inline size_t Storage<T, Container>::getIndex() const {
  return 0;
}

/* indexing */

template <typename T, typename Container>
inline auto Storage<T, Container>::operator[](int i) const -> base_type const& {
  if (i < 0) {
    i = static_cast<int>(size()) + i;
  }
  return getElement(i, data);
}

template <typename T, typename Container>
inline auto Storage<T, Container>::operator[](int i) -> base_type& {
  if (i < 0) {
    i = static_cast<int>(size()) + i;
  }
  return getElement(i, data);
}

template <typename T, typename Container>
template <class Arg, class... Args>
inline auto Storage<T, Container>::operator()(Arg arg, Args... args) const -> base_type const& {
  /* check correct number of arguments*/
  constexpr size_t nargs = sizeof...(Args) + 1;
  constexpr size_t ndims = shape_.ndims();
  if (nargs != ndims) {
    throw IndexError(ndims, nargs);
  }

  size_t index = getIndex<0>(args...);
  return getElement(index, data);
}

template <typename T, typename Container>
template <class Arg, class... Args>
inline auto Storage<T, Container>::operator()(Arg arg, Args... args) -> base_type& {
  /* check correct number of arguments*/
  constexpr size_t nargs = sizeof...(Args) + 1;
  size_t ndims = shape_.ndims();
  if (nargs != ndims) {
    throw IndexError(ndims, nargs);
  }

  size_t index = getIndex<0>(arg, args...);
  return getElement(index, data);
}

/* reshape */
template <typename T, typename Container>
inline auto Storage<T, Container>::reshape(initializer_list<size_t> l)
    -> Storage<T, Container_ref> {
  /* create new shape */
  Shape new_shape = Shape(vector<size_t>{l});

  /* check dimensions match */
  if (!shape_.is_equivalent(new_shape)) {
    throw DimensionsMismatchError(new_shape.getShape(), shape_.getShape());
  }

  /* return new storage with new shape */
  return Storage<T, Container_ref>(getData(), new_shape);
}

template <typename T, typename Container>
inline auto Storage<T, Container>::flatten() -> Storage<T, Container_ref> {
  return reshape({data.size()});
}

template <typename T, typename Container>
inline void Storage<T, Container>::resize(initializer_list<size_t> l) {
  /* create new shape */
  Shape new_shape = Shape(vector<size_t>{l});

  /* check dimensions match */
  if (!shape_.is_equivalent(new_shape)) {
    throw DimensionsMismatchError(new_shape.getShape(), shape_.getShape());
  }
  shape_ = new_shape;
  strides_.fromShape(new_shape);
}

template <typename T, typename Container>
inline void Storage<T, Container>::resize_flat() {
  resize({data.size()});
}

}  // namespace npp

#endif /* storage_hpp */
