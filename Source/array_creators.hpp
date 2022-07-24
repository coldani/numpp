//
//  array_creators.hpp
//  numpp
//
//  Created by Daniele Colombo on 23/07/2022.
//

#ifndef array_creators_h
#define array_creators_h

#include <cstddef>
#include <initializer_list>
#include <vector>

#include "array.hpp"

namespace npp {

using std::initializer_list;
using std::size_t;
using std::vector;

/***************************
 *    full                      *
 ***************************/

template <typename T>
array<T, vector<T>> full(initializer_list<size_t> shape, T value) {
  Shape<T> s((vector<size_t>(shape)));
  auto size = s.calcSize();
  array<T, vector<T>> arr(s);
  for (auto i = 0u; i < size; i++) {
    arr[i] = value;
  }

  return arr;
}

/***************************
 *    eye                      *
 ***************************/

template <typename T>
array<T, vector<T>> eye(size_t size, T value = 1) {
  auto arr = full<T>({size, size}, 0);
  for (auto i = 0u; i < size; i++) {
    arr(i, i) = value;
  }
  return arr;
}

}  // namespace npp

#endif /* array_creators_h */
