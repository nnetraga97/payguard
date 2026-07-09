package com.nnetraga.payguard.simulator.web;

import com.nnetraga.payguard.simulator.web.dto.AuthorizationDecisionResponse;
import com.nnetraga.payguard.simulator.web.dto.AuthorizationRequest;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/authorizations")
class AuthorizationController {

    @PostMapping
    @ResponseStatus(HttpStatus.ACCEPTED)
    AuthorizationDecisionResponse authorize(@Valid @RequestBody AuthorizationRequest request) {
        return AuthorizationDecisionResponse.pending(
                request.requestId(),
                "Decision rules are intentionally left for Milestone 0.2.");
    }
}
