//
//  utilities.hpp
//  numpp
//
//  Created by Daniele Colombo on 21/06/2022.
// DISCLAIMER:
//

#ifndef utilities_hpp
#define utilities_hpp

#include <cstddef>
#include <initializer_list>

#include "exceptions.hpp"

namespace npp {

using std::size_t;

/***************************
 * nested_init_list *
 ***************************/

template <class T, size_t I>
struct nested_init_list {
  using type = std::initializer_list<typename nested_init_list<T, I - 1>::type>;
};

template <class T>
struct nested_init_list<T, 0> {
  using type = T;
};

template <class T, size_t I>
using nested_init_list_t = typename nested_init_list<T, I>::type;

/* */

template <typename T>
class DimensionsChecker {
  template <size_t I>
  void checkDimensionsAs(nested_init_list_t<T, I> l, size_t dims) {
    // check for this dimension
    for (auto e : l) {
      if (e.size() != dims) {
        throw ShapeDeductionError(dims, e.size());
      }
    }
    // go one dimension deeper
    size_t inner_dims = (*(*l.begin()).begin()).size();
    for (auto e : l) {
      checkDimensionsAs<I - 1>(e, inner_dims);
    }
  }

  template <>
  void checkDimensionsAs<2>(nested_init_list_t<T, 2> l, size_t dims) {
    // check for this dimension
    for (auto e : l) {
      if (e.size() != dims) {
        throw ShapeDeductionError(dims, e.size());
      }
    }
  }

 public:
  template <size_t I>
  void check(nested_init_list_t<T, I> l) {
    size_t dims = (*l.begin()).size();
    checkDimensionsAs<I>(l, dims);
  }
  template <>
  void check<1>(nested_init_list_t<T, 1> l) {}
};

}  // namespace npp

#endif /* utilities_hpp */
