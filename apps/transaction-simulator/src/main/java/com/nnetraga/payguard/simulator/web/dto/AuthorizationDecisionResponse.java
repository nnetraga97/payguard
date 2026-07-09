package com.nnetraga.payguard.simulator.web.dto;

import java.time.Instant;

public record AuthorizationDecisionResponse(
        String requestId,
        AuthorizationOutcome outcome,
        String reason,
        Instant decidedAt) {

    public static AuthorizationDecisionResponse pending(String requestId, String reason) {
        return new AuthorizationDecisionResponse(requestId, AuthorizationOutcome.PENDING_REVIEW, reason, Instant.now());
    }
}
