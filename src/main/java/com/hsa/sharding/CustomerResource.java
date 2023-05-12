package com.hsa.sharding;

import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
@RequestMapping("/customers")
public class CustomerResource {

  private final CustomerService customerService;

  @PostMapping
  public ResponseEntity<?> postCustomers() {
    customerService.init();
    return ResponseEntity.ok().build();
  }

  @PostMapping("/categories")
  public ResponseEntity<?> postCustomerCategories() {
    customerService.initCategories();
    return ResponseEntity.ok().build();
  }

}
