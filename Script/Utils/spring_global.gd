extends Node


class DampedSpringParams:
	var m_posPosCoef: float;
	var m_posVelCoef: float;
	var m_velPosCoef: float;
	var m_velVelCoef: float;

class DampedSpringVector2:
	var current_position: Vector2;
	var current_velocity: Vector2;

class DampedSpringFloat:
	var current_position: float;
	var current_velocity: float;


func calc_damped_spring_motion_params(spring_param: DampedSpringParams, dt: float, angularFrequency: float, dampingRatio: float):
	var epsilon = 0.0001;

	if (dampingRatio < 0.0):
		dampingRatio = 0.0;
	if (angularFrequency < 0.0):
		angularFrequency = 0.0;

	if (angularFrequency < epsilon):
		spring_param.m_posPosCoef = 1.0;
		spring_param.m_posVelCoef = 0.0;
		spring_param.m_velPosCoef = 0.0;
		spring_param.m_velVelCoef = 1.0;
		return ;

	if (dampingRatio > 1.0 + epsilon):
		var za = -angularFrequency * dampingRatio;
		var zb = angularFrequency * sqrt(dampingRatio * dampingRatio - 1.0);
		var z1 = za - zb;
		var z2 = za + zb;

		var e1 = exp(z1 * dt);
		var e2 = exp(z2 * dt);

		var invTwoZb = 1.0 / (2.0 * zb);

		var e1_Over_TwoZb = e1 * invTwoZb;
		var e2_Over_TwoZb = e2 * invTwoZb;

		var z1e1_Over_TwoZb = z1 * e1_Over_TwoZb;
		var z2e2_Over_TwoZb = z2 * e2_Over_TwoZb;

		spring_param.m_posPosCoef = e1_Over_TwoZb * z2 - z2e2_Over_TwoZb + e2;
		spring_param.m_posVelCoef = -e1_Over_TwoZb + e2_Over_TwoZb;

		spring_param.m_velPosCoef = (z1e1_Over_TwoZb - z2e2_Over_TwoZb + e2) * z2;
		spring_param.m_velVelCoef = -z1e1_Over_TwoZb + z2e2_Over_TwoZb;
	else:
		if (dampingRatio < 1.0 - epsilon):
			var omegaZeta = angularFrequency * dampingRatio;
			var alpha = angularFrequency * sqrt(1.0 - dampingRatio * dampingRatio);

			var expTerm = exp(-omegaZeta * dt);
			var cosTerm = cos(alpha * dt);
			var sinTerm = sin(alpha * dt);

			var invAlpha = 1.0 / alpha;

			var expSin = expTerm * sinTerm;
			var expCos = expTerm * cosTerm;
			var expOmegaZetaSin_Over_Alpha = expTerm * omegaZeta * sinTerm * invAlpha;

			spring_param.m_posPosCoef = expCos + expOmegaZetaSin_Over_Alpha;
			spring_param.m_posVelCoef = expSin * invAlpha;

			spring_param.m_velPosCoef = -expSin * alpha - omegaZeta * expOmegaZetaSin_Over_Alpha;
			spring_param.m_velVelCoef = expCos - expOmegaZetaSin_Over_Alpha;

		else:
			var expTerm = exp(-angularFrequency * dt);
			var timeExp = dt * expTerm;
			var timeExpFreq = timeExp * angularFrequency;

			spring_param.m_posPosCoef = timeExpFreq + expTerm;
			spring_param.m_posVelCoef = timeExp;

			spring_param.m_velPosCoef = -angularFrequency * timeExpFreq;
			spring_param.m_velVelCoef = -timeExpFreq + expTerm;


func compute_spring_goal_vector_2(desired_goal: Vector2, spring_data: DampedSpringVector2, spring_param: DampedSpringParams):
	var equilibriumPos = desired_goal;

	var oldPos = spring_data.current_position - equilibriumPos;
	var oldVel = spring_data.current_velocity;

	spring_data.current_position = oldPos * spring_param.m_posPosCoef + oldVel * spring_param.m_posVelCoef + equilibriumPos;
	spring_data.current_velocity = oldPos * spring_param.m_velPosCoef + oldVel * spring_param.m_velVelCoef;


func compute_spring_goal_float(desired_goal: float, spring_data: DampedSpringFloat, spring_param: DampedSpringParams):
	var equilibriumPos = desired_goal;

	var oldPos = spring_data.current_position - equilibriumPos;
	var oldVel = spring_data.current_velocity;

	spring_data.current_position = oldPos * spring_param.m_posPosCoef + oldVel * spring_param.m_posVelCoef + equilibriumPos;
	spring_data.current_velocity = oldPos * spring_param.m_velPosCoef + oldVel * spring_param.m_velVelCoef;
