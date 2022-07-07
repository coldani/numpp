//
//  exceptions.hpp
//  numpp
//
//  Created by Daniele Colombo on 06/07/2022.
//

#ifndef exceptions_h
#define exceptions_h

#include <sstream>
#include <string>

namespace npp {

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

}  // namespace npp

#endif /* exceptions_h */
