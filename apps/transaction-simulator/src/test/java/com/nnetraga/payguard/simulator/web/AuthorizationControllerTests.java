package com.nnetraga.payguard.simulator.web;

import static org.hamcrest.Matchers.is;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;

@WebMvcTest(AuthorizationController.class)
class AuthorizationControllerTests {

    @Autowired
    private MockMvc mockMvc;

    @Test
    void acceptsValidAuthorizationRequest() throws Exception {
        mockMvc.perform(post("/api/authorizations")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {
                                  "requestId": "auth-001",
                                  "accountToken": "acct_tok_001",
                                  "amount": 42.50,
                                  "currency": "USD",
                                  "merchantCategoryCode": "5411",
                                  "merchantCountry": "US",
                                  "channel": "CARD_NOT_PRESENT",
                                  "occurredAt": "2026-07-09T15:00:00Z",
                                  "cardLastFour": "4242"
                                }
                                """))
                .andExpect(status().isAccepted())
                .andExpect(jsonPath("$.requestId", is("auth-001")))
                .andExpect(jsonPath("$.outcome", is("PENDING_REVIEW")));
    }

    @Test
    void rejectsInvalidAuthorizationRequest() throws Exception {
        mockMvc.perform(post("/api/authorizations")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {
                                  "requestId": "",
                                  "amount": 0,
                                  "currency": "US",
                                  "merchantCountry": "USA",
                                  "channel": "CARD_NOT_PRESENT",
                                  "occurredAt": "2026-07-09T15:00:00Z",
                                  "cardLastFour": "424242"
                                }
                                """))
                .andExpect(status().isBadRequest());
    }
}
