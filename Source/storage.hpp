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
#include <utility>
#include <vector>

namespace npp {


using std::initializer_list;
using std::size_t;
using std::vector;

/*********************
 * DEFINITION
 *********************/

template <typename T>
class Storage {
  vector<T> data{};

  bool out_of_bound(int i);

 public:
  Storage(initializer_list<T> l);
  explicit Storage(size_t capacity);

  constexpr size_t size() const noexcept { return data.size(); }
  constexpr size_t capacity() const noexcept { return data.capacity(); }

  T const& operator[](int i) const;
  T& operator[](int i);
};

/*************************
 * IMPLEMENTATION
 **************************/

template <typename T>
Storage<T>::Storage(initializer_list<T> l) : data(l) {}

template <typename T>
Storage<T>::Storage(size_t capacity) {
  data.reserve(capacity);
}

template <typename T>
bool Storage<T>::out_of_bound(int i) {
  if (i < 0) {
    return static_cast<size_t>(-i) >= size();
  }
  return static_cast<size_t>(i) >= size();
}

template <typename T>
T const& Storage<T>::operator[](int i) const {
  if (i < 0) {
    i = static_cast<int>(size()) + i;
  }
  return data[i];
}

template <typename T>
T& Storage<T>::operator[](int i) {
  return const_cast<T&>(std::as_const(*this)[i]);
}

}  // namespace npp

#endif /* storage_hpp */
