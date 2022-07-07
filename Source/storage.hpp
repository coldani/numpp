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
  base_type& getElement(int i, vector<base_type>& vec);
  base_type& getElement(int i, vector<pointer_type>& vec);
  base_type const& getElement(int i, vector<base_type> const& vec) const;
  base_type const& getElement(int i, vector<pointer_type> const& vec) const;

 public:
  /* constructors */
  Storage() = default;
  explicit Storage(size_t capacity);
  Storage(initializer_list<T> l);

  /* copy and move constructors*/
  Storage(Storage<T, Container_noref>& other);
  Storage(Storage<T, Container_ref>& other);
  Storage(Storage<T, Container_noref>&& other);
  Storage(Storage<T, Container_ref>&& other);
  Storage(Container_ref c);

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

  iterator begin() { return data.begin(); }
  const_iterator cbegin() { return data.cbegin(); }
  iterator end() { return data.end(); }
  const_iterator cend() { return data.cend(); }
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
inline Storage<T, Container>::Storage(initializer_list<T> l)
    : data(l), shape_(l), strides_(shape_) {}

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
    : data(std::move(other.getData())),
      shape_(std::move(other.shape())),
      strides_(std::move(other.strides())) {}

template <typename T, typename Container>
inline Storage<T, Container>::Storage(Container_ref c)
    : data(c), shape_(capacity()), strides_(shape_) {}

/* helper functions */

template <typename T, typename Container>
inline bool Storage<T, Container>::out_of_bound(int i) {
  if (i < 0) {
    return static_cast<size_t>(-i) >= size();
  }
  return static_cast<size_t>(i) >= size();
}

template <typename T, typename Container>
inline auto Storage<T, Container>::getElement(int i, vector<base_type>& vec) -> base_type& {
  return vec[i];
}

template <typename T, typename Container>
inline auto Storage<T, Container>::getElement(int i, vector<pointer_type>& vec) -> base_type& {
  return *vec[i];
}

template <typename T, typename Container>
inline auto Storage<T, Container>::getElement(int i, vector<base_type> const& vec) const
    -> base_type const& {
  return vec[i];
}

template <typename T, typename Container>
inline auto Storage<T, Container>::getElement(int i, vector<pointer_type> const& vec) const
    -> base_type const& {
  return *vec[i];
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

}  // namespace npp

#endif /* storage_hpp */
