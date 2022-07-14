//
//  exceptions.hpp
//  numpp
//
//  Created by Daniele Colombo on 06/07/2022.
//

#ifndef exceptions_h
#define exceptions_h

#include <cstddef>
#include <sstream>
#include <string>
#include <vector>

namespace npp {
using std::size_t;
using std::vector;

struct ShapeDeductionError : public std::exception {
  size_t const first;
  size_t const second;
  std::string message;

  ShapeDeductionError(size_t first, size_t second)
      : first(first), second(second), message(makeMessage()) {}

  std::string makeMessage() {
    std::stringstream ss;
    ss << "Cannot properly deduce shape: different dimensions " << first << " and " << second;
    return ss.str();
  }
  const char* what() const throw() { return message.c_str(); }
};

struct IndexError : public std::exception {
  size_t const expected;
  size_t const received;
  std::string message;

  IndexError(size_t expected, size_t received)
      : expected(expected), received(received), message(makeMessage()) {}

  std::string makeMessage() {
    std::stringstream ss;
    ss << "Wrong number of indices passed: passed " << received << ", expected " << expected;
    return ss.str();
  }
  const char* what() const throw() { return message.c_str(); }
};

struct DimensionsMismatchError : public std::exception {
  vector<size_t> const first;
  vector<size_t> const second;
  std::string message;

  DimensionsMismatchError(vector<size_t> const& first, vector<size_t> const& second)
      : first(first), second(second), message(makeMessage()) {}
  DimensionsMismatchError(size_t first, size_t second)
      : first({first}), second({second}), message(makeMessage(first, second)) {}

  std::string makeMessage() {
    /* get first dims to stringstream*/
    std::stringstream firstss;
    firstss << "(";
    for (size_t i = 0; i < first.size(); i++) {
      firstss << first[i];
      if (i + 1 < first.size()) firstss << ", ";
    }
    firstss << ")";

    /* get second dims to stringstream*/
    std::stringstream secondss;
    secondss << "(";
    for (size_t i = 0; i < second.size(); i++) {
      secondss << second[i];
      if (i + 1 < second.size()) secondss << ", ";
    }
    secondss << ")";

    /* concatenate everything */
    std::stringstream ss;
    ss << "Dimensions mismatch: " << firstss.str() << " is not compatible with " << secondss.str();
    return ss.str();
  }

  std::string makeMessage(size_t first, size_t second) {
    std::stringstream ss;
    ss << "Dimensions mismatch: " << first << " dimensions vs " << second << " dimensions.";
    return ss.str();
  }

  const char* what() const throw() { return message.c_str(); }
};

struct InvalidRange : public std::exception {
  int const start;
  int const end;
  int const step;
  std::string message;

  InvalidRange(int start, int end, int step)
      : start(start), end(end), step(step), message(makeMessage()) {}

  std::string makeMessage() {
    std::stringstream ss;
    ss << "Range(" << start << ", " << end << ", " << step << ") is invalid.";
    return ss.str();
  }
  const char* what() const throw() { return message.c_str(); }
};

}  // namespace npp

#endif /* exceptions_h */
