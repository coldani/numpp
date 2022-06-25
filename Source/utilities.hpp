//
//  utilities.hpp
//  numpp
//
//  Created by Daniele Colombo on 21/06/2022.
//

#ifndef utilities_hpp
#define utilities_hpp

#include <cstddef>
#include <initializer_list>

namespace npp {

using std::size_t;

/***************************
 * nested_initializer_list *
 ***************************/

template <class T, size_t I>
struct nested_initializer_list {
  using type =
      std::initializer_list<typename nested_initializer_list<T, I - 1>::type>;
};

template <class T>
struct nested_initializer_list<T, 0> {
  using type = T;
};

template <class T, size_t I>
using nested_initializer_list_t = typename nested_initializer_list<T, I>::type;

}  // namespace npp

#endif /* utilities_hpp */
