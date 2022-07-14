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
#include <vector>

#include "exceptions.hpp"

namespace npp {

using std::initializer_list;
using std::size_t;
using std::vector;

/***************************
 * nested_init_list *
 ***************************/

template <class T, size_t I>
struct nested_init_list {
  using type = initializer_list<typename nested_init_list<T, I - 1>::type>;
};

template <class T>
struct nested_init_list<T, 0> {
  using type = T;
};

template <class T, size_t I>
using nested_init_list_t = typename nested_init_list<T, I>::type;

/***************************
 * DimensionsChecker *
 ***************************/

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

/***************************
 * indices_from_slices *
 ***************************/

inline vector<vector<int>> indices_from_slices(vector<vector<int>> const& vec_of_slices) {
  vector<vector<int>> indices{{}};
  for (auto const& slice : vec_of_slices) {
    vector<vector<int>> temp_indices;
    for (auto const& temp_index : indices) {
      for (auto const i : slice) {
        temp_indices.push_back(temp_index);
        temp_indices.back().push_back(i);
      }
    }
    indices = std::move(temp_indices);
  }
  return indices;
}

/***************************
 * all, slice and range *
 ***************************/

struct all {
  template <typename T>
  vector<int> convert(T const& storage, size_t dim) {
    size_t size = storage.shape()[dim];
    vector<int> indices;
    indices.reserve(size);
    for (int i = 0; i < static_cast<int>(size); i++) {
      indices.push_back(i);
    }
    return indices;
  }
};

struct slice {
  vector<int> indices;

  slice(initializer_list<int> l) : indices(l) {}
  vector<int> convert() { return indices; }
};

struct range {
  int start;
  int end;
  int step;

  range(int start, int end, int step = 1) : start(start), end(end), step(step) {}

  template <typename T>
  vector<int> convert(T const& storage, size_t dim) {
    // convert indices
    size_t ceiling = storage.shape()[dim];
    start = convertIndex(start, ceiling);
    end = convertIndex(end, ceiling);
    // check range inputs are OK - note doesn't check they fit into storage
    if (step == 0 || (step > 0 && end < start) || (step < 0 && end > start)) {
      throw InvalidRange(start, end, step);
    }

    // convert range
    vector<int> indices;
    if (step > 0) {
      for (int i = start; i <= end; i += step) {
        indices.push_back(i);
      }
    } else {
      for (int i = start; i >= end; i += step) {
        indices.push_back(i);
      }
    }
    return indices;
  }

 private:
  int convertIndex(int index, size_t ceiling) {
    if (index < 0) {
      index = static_cast<int>(ceiling) + index;
    }
    return index;
  }
};

}  // namespace npp

#endif /* utilities_hpp */
